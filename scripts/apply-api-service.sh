#!/usr/bin/env bash
# Apply the dev api-service Terraform stack in the correct bootstrap order.
#
# This script supports the two-phase EKS bootstrap:
#   1. eks-core with create_managed_node_group=false
#   2. eks-sg-rules
#   3. eks-core with create_managed_node_group=true
#   4. eks-irsa
#   5. eks-karpenter
#   6. eks-addons-irsa
#   7. eks-addons
#   8. init addon values
#   9. eks-argocd-bootstrap
#  10. ssm-parameters (only with --include-ssm)
#
# It intentionally stops before ArgoCD bootstrap if addon values were modified,
# because GitOps values must be committed and pushed before ArgoCD syncs them.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

AWS_REGION="${AWS_REGION:-ap-northeast-2}"
CLUSTER_NAME="${CLUSTER_NAME:-safespot-dev-eks}"
NODEGROUP_PREFIX="${NODEGROUP_PREFIX:-safespot-dev-mng-}"

AUTO_APPROVE=false
CLEANUP_FAILED_NODEGROUPS=false
INCLUDE_SSM=false
SKIP_KARPENTER=false
SKIP_INIT_VALUES=false
SKIP_ARGOCD=false
CONTINUE_AFTER_VALUES_CHANGE=false

usage() {
  cat <<USAGE
Usage:
  bash scripts/apply-api-service.sh [options]

Options:
  --auto-approve                  Run terraform apply without interactive approval.
  --cleanup-failed-nodegroups     Delete EKS node groups in CREATE_FAILED before retrying.
  --include-ssm                   Also apply terraform/environments/dev/ssm-parameters (skipped by default).
  --skip-karpenter                Skip eks-karpenter and Karpenter values injection.
  --skip-init-values              Skip scripts/init-addon-values.sh.
  --skip-argocd                   Skip eks-argocd-bootstrap and ArgoCD waits.
  --continue-after-values-change  Continue even if init-addon-values.sh changed GitOps values.
  -h, --help                      Show this help.

Environment:
  AWS_REGION        Default: ap-northeast-2
  CLUSTER_NAME      Default: safespot-dev-eks
  NODEGROUP_PREFIX  Default: safespot-dev-mng-
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --auto-approve) AUTO_APPROVE=true ;;
    --cleanup-failed-nodegroups) CLEANUP_FAILED_NODEGROUPS=true ;;
    --skip-ssm)
      echo "WARN: --skip-ssm is deprecated. SSM is skipped by default. Use --include-ssm to run it." >&2
      ;;
    --include-ssm) INCLUDE_SSM=true ;;
    --skip-karpenter) SKIP_KARPENTER=true ;;
    --skip-init-values) SKIP_INIT_VALUES=true ;;
    --skip-argocd) SKIP_ARGOCD=true ;;
    --continue-after-values-change) CONTINUE_AFTER_VALUES_CHANGE=true ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

log() {
  printf "\n==> %s\n" "$*"
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "ERROR: required command not found: $1" >&2
    exit 1
  fi
}

terraform_apply() {
  local root="$1"
  shift

  log "terraform init: ${root}"
  terraform -chdir="${REPO_ROOT}/${root}" init

  log "terraform plan: ${root}"
  terraform -chdir="${REPO_ROOT}/${root}" plan -out=.tfplan.codex "$@"

  log "terraform apply: ${root}"
  if [[ "${AUTO_APPROVE}" == "true" ]]; then
    terraform -chdir="${REPO_ROOT}/${root}" apply .tfplan.codex
  else
    terraform -chdir="${REPO_ROOT}/${root}" apply .tfplan.codex
  fi

  rm -f "${REPO_ROOT}/${root}/.tfplan.codex"
}

cluster_exists() {
  aws eks describe-cluster \
    --region "${AWS_REGION}" \
    --name "${CLUSTER_NAME}" \
    >/dev/null 2>&1
}

cleanup_failed_nodegroups() {
  if ! cluster_exists; then
    log "EKS cluster does not exist yet. Skipping failed node group cleanup."
    return
  fi

  local nodegroups
  nodegroups="$(aws eks list-nodegroups \
    --region "${AWS_REGION}" \
    --cluster-name "${CLUSTER_NAME}" \
    --query 'nodegroups[]' \
    --output text)"

  if [[ -z "${nodegroups}" || "${nodegroups}" == "None" ]]; then
    log "No existing EKS node groups found."
    return
  fi

  local ng status
  for ng in ${nodegroups}; do
    if [[ "${ng}" != "${NODEGROUP_PREFIX}"* ]]; then
      echo "  ${ng}: skipping cleanup check; name does not match prefix ${NODEGROUP_PREFIX}"
      continue
    fi

    status="$(aws eks describe-nodegroup \
      --region "${AWS_REGION}" \
      --cluster-name "${CLUSTER_NAME}" \
      --nodegroup-name "${ng}" \
      --query 'nodegroup.status' \
      --output text)"

    if [[ "${status}" != "CREATE_FAILED" ]]; then
      continue
    fi

    if [[ "${CLEANUP_FAILED_NODEGROUPS}" != "true" ]]; then
      echo "ERROR: node group ${ng} is CREATE_FAILED." >&2
      echo "Re-run with --cleanup-failed-nodegroups to delete it before retrying." >&2
      exit 1
    fi

    log "Deleting failed node group: ${ng}"
    aws eks delete-nodegroup \
      --region "${AWS_REGION}" \
      --cluster-name "${CLUSTER_NAME}" \
      --nodegroup-name "${ng}" \
      >/dev/null

    aws eks wait nodegroup-deleted \
      --region "${AWS_REGION}" \
      --cluster-name "${CLUSTER_NAME}" \
      --nodegroup-name "${ng}"
  done
}

wait_for_cluster_active() {
  log "Waiting for EKS cluster ACTIVE: ${CLUSTER_NAME}"
  aws eks wait cluster-active \
    --region "${AWS_REGION}" \
    --name "${CLUSTER_NAME}"
}

wait_for_nodegroups_active() {
  log "Waiting for EKS node groups ACTIVE"

  local deadline=$((SECONDS + 3600))
  local nodegroups ng status

  while ((SECONDS < deadline)); do
    nodegroups="$(aws eks list-nodegroups \
      --region "${AWS_REGION}" \
      --cluster-name "${CLUSTER_NAME}" \
      --query 'nodegroups[]' \
      --output text)"

    if [[ -n "${nodegroups}" && "${nodegroups}" != "None" ]]; then
      local all_active=true
      for ng in ${nodegroups}; do
        status="$(aws eks describe-nodegroup \
          --region "${AWS_REGION}" \
          --cluster-name "${CLUSTER_NAME}" \
          --nodegroup-name "${ng}" \
          --query 'nodegroup.status' \
          --output text)"

        echo "  ${ng}: ${status}"
        if [[ "${status}" == "CREATE_FAILED" || "${status}" == "DEGRADED" ]]; then
          echo "ERROR: node group ${ng} reached ${status}." >&2
          exit 1
        fi
        if [[ "${status}" != "ACTIVE" ]]; then
          all_active=false
        fi
      done

      if [[ "${all_active}" == "true" ]]; then
        return
      fi
    fi

    sleep 30
  done

  echo "ERROR: timed out waiting for EKS node groups to become ACTIVE." >&2
  exit 1
}

wait_for_nodes_ready() {
  if ! command -v kubectl >/dev/null 2>&1; then
    log "kubectl not found. Skipping Kubernetes node readiness wait."
    return
  fi

  log "Waiting for Kubernetes nodes Ready"
  local deadline=$((SECONDS + 1800))

  while ((SECONDS < deadline)); do
    if kubectl get nodes >/tmp/codex-kubectl-nodes.txt 2>/dev/null; then
      cat /tmp/codex-kubectl-nodes.txt
      if awk 'NR > 1 { count++; if ($2 != "Ready") bad=1 } END { exit (count > 0 && !bad) ? 0 : 1 }' /tmp/codex-kubectl-nodes.txt; then
        return
      fi
    fi
    sleep 20
  done

  echo "ERROR: timed out waiting for Kubernetes nodes to become Ready." >&2
  exit 1
}

run_init_values() {
  if [[ "${SKIP_INIT_VALUES}" == "true" ]]; then
    log "Skipping addon values initialization."
    return
  fi

  log "Populating addon values from Terraform outputs"
  if [[ "${SKIP_KARPENTER}" == "true" ]]; then
    bash "${REPO_ROOT}/scripts/init-addon-values.sh" --skip-karpenter
  else
    bash "${REPO_ROOT}/scripts/init-addon-values.sh"
  fi

  if git -C "${REPO_ROOT}" diff --quiet -- terraform/addons &&
    git -C "${REPO_ROOT}" diff --cached --quiet -- terraform/addons; then
    log "No addon values changes detected."
    return
  fi

  if [[ "${CONTINUE_AFTER_VALUES_CHANGE}" == "true" ]]; then
    log "Addon values changed, but continuing because --continue-after-values-change was set."
    return
  fi

  cat <<MSG >&2

ERROR: addon values changed.
Commit and push these values before ArgoCD bootstrap/sync, then re-run with:
  bash scripts/apply-api-service.sh --auto-approve --skip-init-values

To also apply ssm-parameters in the same run:
  bash scripts/apply-api-service.sh --auto-approve --skip-init-values --include-ssm

Suggested commands:
  git diff terraform/addons/
  git add terraform/addons/
  git commit -m "chore: update addon values"
  git push origin \$(git rev-parse --abbrev-ref HEAD)

MSG
  exit 20
}

wait_for_argocd_apps() {
  if [[ "${SKIP_ARGOCD}" == "true" ]]; then
    log "Skipping ArgoCD wait."
    return
  fi

  if ! command -v kubectl >/dev/null 2>&1; then
    log "kubectl not found. Skipping ArgoCD wait."
    return
  fi

  log "Waiting for ArgoCD applications to become Synced/Healthy"
  local deadline=$((SECONDS + 1800))

  while ((SECONDS < deadline)); do
    if kubectl -n argocd get applications >/tmp/codex-argocd-apps.txt 2>/dev/null; then
      cat /tmp/codex-argocd-apps.txt
      if awk 'NR > 1 { if ($2 != "Synced" || $3 != "Healthy") bad=1 } END { exit bad ? 1 : 0 }' /tmp/codex-argocd-apps.txt; then
        return
      fi
    fi
    sleep 30
  done

  echo "ERROR: timed out waiting for ArgoCD applications to become Synced/Healthy." >&2
  exit 1
}

require_cmd terraform
require_cmd aws

log "Starting api-service apply automation"

if [[ "${AUTO_APPROVE}" != "true" ]]; then
  cat <<MSG
This script will run Terraform apply for the api-service stack.

Cluster: ${CLUSTER_NAME}
Region : ${AWS_REGION}

Use --auto-approve to skip this confirmation.
MSG
  read -r -p "Continue? [y/N] " answer
  case "${answer}" in
    y | Y | yes | YES) ;;
    *)
      echo "Aborted."
      exit 1
      ;;
  esac
fi

cleanup_failed_nodegroups

terraform_apply "terraform/environments/dev/api-service/eks-core" -var=create_managed_node_group=false
wait_for_cluster_active

terraform_apply "terraform/environments/dev/api-service/eks-sg-rules"

terraform_apply "terraform/environments/dev/api-service/eks-core" -var=create_managed_node_group=true
wait_for_nodegroups_active
wait_for_nodes_ready

terraform_apply "terraform/environments/dev/api-service/eks-irsa"

if [[ "${SKIP_KARPENTER}" != "true" ]]; then
  terraform_apply "terraform/environments/dev/api-service/eks-karpenter"
fi

terraform_apply "terraform/environments/dev/api-service/eks-addons-irsa"

terraform_apply "terraform/environments/dev/api-service/eks-addons"

run_init_values

if [[ "${SKIP_ARGOCD}" != "true" ]]; then
  terraform_apply "terraform/environments/dev/api-service/eks-argocd-bootstrap"
  wait_for_argocd_apps
fi

if [[ "${INCLUDE_SSM}" == "true" ]]; then
  terraform_apply "terraform/environments/dev/ssm-parameters"
fi

log "api-service apply automation completed"
