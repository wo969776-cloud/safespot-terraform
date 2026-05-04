#!/usr/bin/env bash
# Populate IRSA role ARNs in addon values files from Terraform outputs.
# Run this after terraform apply for eks-irsa, eks-karpenter, and eks-addons-irsa.
#
# Usage:
#   bash scripts/init-addon-values.sh
#   bash scripts/init-addon-values.sh --dry-run   (print values without modifying files)
#
# Requires: terraform (>= 1.6), yq (v4) or sed as fallback

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
DRY_RUN=false

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    *) echo "Unknown argument: $arg" && exit 1 ;;
  esac
done

tf_output() {
  terraform -chdir="${REPO_ROOT}/$1" output -raw "$2"
}

echo "==> Reading Terraform outputs..."

ALB_ROLE_ARN=$(tf_output "terraform/environments/dev/api-service/eks-irsa" "alb_controller_irsa_role_arn")
KARPENTER_ROLE_ARN=$(tf_output "terraform/environments/dev/api-service/eks-karpenter" "karpenter_controller_role_arn")
EXTERNAL_DNS_ROLE_ARN=$(tf_output "terraform/environments/dev/api-service/eks-addons-irsa" "external_dns_irsa_role_arn")
EXTERNAL_SECRETS_ROLE_ARN=$(tf_output "terraform/environments/dev/api-service/eks-addons-irsa" "external_secrets_irsa_role_arn")

echo ""
echo "  ALB Controller      : ${ALB_ROLE_ARN}"
echo "  Karpenter           : ${KARPENTER_ROLE_ARN}"
echo "  ExternalDNS         : ${EXTERNAL_DNS_ROLE_ARN}"
echo "  External Secrets    : ${EXTERNAL_SECRETS_ROLE_ARN}"
echo ""

if [[ "${DRY_RUN}" == "true" ]]; then
  echo "(dry-run) No files modified."
  exit 0
fi

set_role_arn() {
  local file="${REPO_ROOT}/$1"
  local arn="$2"

  if command -v yq &>/dev/null; then
    yq e ".serviceAccount.annotations[\"eks.amazonaws.com/role-arn\"] = \"${arn}\"" -i "${file}"
  else
    sed -i "s|eks.amazonaws.com/role-arn:.*|eks.amazonaws.com/role-arn: \"${arn}\"|" "${file}"
  fi
  echo "  updated: $1"
}

echo "==> Writing role ARNs to values files..."
set_role_arn "terraform/addons/aws-load-balancer-controller/values-dev.yaml" "${ALB_ROLE_ARN}"
set_role_arn "terraform/addons/karpenter/values-dev.yaml" "${KARPENTER_ROLE_ARN}"
set_role_arn "terraform/addons/external-dns/values-dev.yaml" "${EXTERNAL_DNS_ROLE_ARN}"
set_role_arn "terraform/addons/external-secrets-operator/values-dev.yaml" "${EXTERNAL_SECRETS_ROLE_ARN}"

echo ""
echo "Done. Review and commit:"
echo "  git diff terraform/addons/"
