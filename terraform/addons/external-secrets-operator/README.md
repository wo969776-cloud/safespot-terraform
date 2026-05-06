# External Secrets Operator (ESO)

## Charts

| Chart | Source | Version | Managed by |
|---|---|---|---|
| Controller | `https://charts.external-secrets.io` | 0.11.0 | `argocd/external-secrets-operator.yaml` (wave 1) |
| ClusterSecretStore | local `chart/` (this directory) | 0.1.0 | `argocd/eso-configs.yaml` (wave 2) |

## CRD Installation

`installCRDs: true` is set in `values-dev.yaml` so CRDs (`ExternalSecret`, `ClusterSecretStore`, etc.) are installed with the controller chart. On upgrades, verify CRD compatibility before upgrading.

## Wrapper Chart (`chart/`)

`ClusterSecretStore` is defined as a Helm template inside `chart/`. Values are managed in `chart/values-dev.yaml`.

```
chart/
├── Chart.yaml
├── values.yaml          # defaults (region, service, serviceAccountRef)
├── values-dev.yaml      # dev environment overrides
└── templates/
    └── clustersecretstore-aws.yaml
```

### Configurable values

| Field | Description | Default |
|---|---|---|
| `clusterSecretStore.name` | Name referenced by `ExternalSecret.clusterSecretStoreRef.name` | `ssm-parameter-store` |
| `clusterSecretStore.provider.region` | AWS region | `ap-northeast-2` |
| `clusterSecretStore.provider.service` | Backend service for AWS SSM Parameter Store | `ParameterStore` |
| `clusterSecretStore.serviceAccountRef.name` | ESO controller ServiceAccount name | `external-secrets` |
| `clusterSecretStore.serviceAccountRef.namespace` | ESO controller namespace | `external-secrets` |

## IRSA

ESO requires an IAM Role for Service Accounts provisioned by Terraform (`eks-addons-irsa` environment). Run the init script after Terraform apply to populate the role ARN in `values-dev.yaml`:

```bash
bash scripts/init-addon-values.sh
```

Source: `terraform -chdir=terraform/environments/dev/api-service/eks-addons-irsa output -raw external_secrets_irsa_role_arn`

The role `safespot-dev-external-secrets-irsa` grants:
- `ssm:GetParameter`, `ssm:GetParameters`, `ssm:GetParametersByPath`

See `docs/irsa-contract.md` for the full binding table.

## Deployment

Both ArgoCD Applications are picked up automatically by `argocd/root-platform-addons.yaml` (app-of-apps).

```
Wave 1: argocd/external-secrets-operator.yaml  → ESO controller + CRD install
Wave 2: argocd/eso-configs.yaml                → ClusterSecretStore sync
```

App deploy repos reference the store with:
```yaml
clusterSecretStoreRef:
  name: ssm-parameter-store
  kind: ClusterSecretStore
```
