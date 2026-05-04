# IRSA Contract

This document is the authoritative reference for IRSA (IAM Roles for Service Accounts) bindings in the SafeSpot dev cluster.

**Rule**: Never change the namespace or service account name for an existing binding without first updating the Terraform trust policy. The OIDC subject `system:serviceaccount:<namespace>:<sa-name>` is baked into the IAM role trust policy.

---

## Bindings

| Component | Service Account | Namespace | Terraform env | State key |
|---|---|---|---|---|
| ALB Controller | `aws-load-balancer-controller` | `kube-system` | `eks-irsa` | `environments/dev/api-service/eks-irsa/terraform.tfstate` |
| Karpenter | `karpenter` | `kube-system` | `eks-karpenter` | `environments/dev/api-service/eks-karpenter/terraform.tfstate` |
| ExternalDNS | `external-dns` | `external-dns` | `eks-addons-irsa` | `environments/dev/api-service/eks-addons-irsa/terraform.tfstate` |
| External Secrets | `external-secrets` | `external-secrets` | `eks-addons-irsa` | `environments/dev/api-service/eks-addons-irsa/terraform.tfstate` |

---

## Role ARN Sources

Each `values-dev.yaml` file has `serviceAccount.annotations.eks.amazonaws.com/role-arn` set by `scripts/init-addon-values.sh`, which reads from these Terraform outputs.

| Component | Terraform output command | Values file |
|---|---|---|
| ALB Controller | `terraform -chdir=terraform/environments/dev/api-service/eks-irsa output -raw alb_controller_irsa_role_arn` | `terraform/addons/aws-load-balancer-controller/values-dev.yaml` |
| Karpenter | `terraform -chdir=terraform/environments/dev/api-service/eks-karpenter output -raw karpenter_controller_role_arn` | `terraform/addons/karpenter/values-dev.yaml` |
| ExternalDNS | `terraform -chdir=terraform/environments/dev/api-service/eks-addons-irsa output -raw external_dns_irsa_role_arn` | `terraform/addons/external-dns/values-dev.yaml` |
| External Secrets | `terraform -chdir=terraform/environments/dev/api-service/eks-addons-irsa output -raw external_secrets_irsa_role_arn` | `terraform/addons/external-secrets-operator/values-dev.yaml` |

Populate all at once:

```bash
bash scripts/init-addon-values.sh
```

Dry-run (print values without modifying files):

```bash
bash scripts/init-addon-values.sh --dry-run
```

---

## Initialisation Sequence

The values files must be populated after Terraform apply and before ArgoCD sync:

```
1. terraform apply (eks-irsa, eks-karpenter, eks-addons-irsa)
2. bash scripts/init-addon-values.sh
3. git add terraform/addons/ && git commit && git push
4. ArgoCD sync (platform-addons)
```

---

## Verification

```bash
# Confirm the service account annotation on a running pod
kubectl get serviceaccount aws-load-balancer-controller -n kube-system \
  -o jsonpath='{.metadata.annotations.eks\.amazonaws\.com/role-arn}'

# Confirm the IAM role trust policy matches the SA subject
aws iam get-role \
  --role-name safespot-dev-aws-load-balancer-controller-irsa \
  --query 'Role.AssumeRolePolicyDocument.Statement[0].Condition'

# Verify AWS token projection inside the pod
kubectl exec -n kube-system \
  $(kubectl get pod -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller -o name | head -1) \
  -- cat /var/run/secrets/eks.amazonaws.com/serviceaccount/token | cut -d. -f2 | base64 -d 2>/dev/null | python3 -m json.tool
```
