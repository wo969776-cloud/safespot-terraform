# External Secrets Operator (ESO)

## Chart

- **Repository**: https://charts.external-secrets.io
- **Chart**: external-secrets
- **Chart Version**: 0.11.0

## CRD Installation

`installCRDs: true` is set so CRDs (`ExternalSecret`, `ClusterSecretStore`, `SecretStore`, etc.) are installed as part of the Helm release. On upgrades, ensure CRDs are compatible with the new chart version before upgrading.

## ClusterSecretStore

`cluster-secret-store-dev.yaml` defines a cluster-scoped secret store backed by AWS Secrets Manager. Apply this manifest **after** ESO is fully running and CRDs are established:

```bash
kubectl apply -f terraform/addons/external-secrets-operator/cluster-secret-store-dev.yaml
```

The store uses IRSA via the `external-secrets` service account in the `external-secrets` namespace.

## IRSA Requirement

ESO requires an IAM Role for Service Accounts (IRSA) provisioned by Terraform in:

```
terraform/environments/dev/api-service/eks-addons-irsa/
```

The role `safespot-dev-external-secrets-irsa` grants:
- `secretsmanager:GetSecretValue`, `secretsmanager:DescribeSecret` on all Secrets Manager resources
- `ssm:GetParameter`, `ssm:GetParameters`, `ssm:GetParametersByPath` on all SSM Parameter Store resources

## IRSA Role ARN

Run the init script after Terraform apply to populate the role ARN in `values-dev.yaml`:

```bash
bash scripts/init-addon-values.sh
```

Source: `terraform -chdir=terraform/environments/dev/api-service/eks-addons-irsa output -raw external_secrets_irsa_role_arn`

See `docs/irsa-contract.md` for the full binding table.

## Deployment

This chart is deployed via ArgoCD (sync-wave: 1). See `argocd/external-secrets-operator.yaml`.
App deploy repos reference this store using `ExternalSecret` resources pointing to `clusterSecretStoreRef.name: aws-secrets-manager`.
