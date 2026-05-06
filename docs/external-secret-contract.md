# External Secrets Contract

This document defines how application secrets are managed using the External Secrets Operator (ESO) and AWS SSM Parameter Store in the SafeSpot dev environment.

---

## Architecture

```
AWS SSM Parameter Store
      │
      │  (IRSA: safespot-dev-external-secrets-irsa)
      ▼
ClusterSecretStore: ssm-parameter-store
      │
      │  (referenced by ExternalSecret resources)
      ▼
ExternalSecret (per app, owned by app deploy repo)
      │
      ▼
Kubernetes Secret (created/synced by ESO)
      │
      ▼
Application Pod (mounts secret as env or volume)
```

---

## Platform Repo Owns

The `safespot-terraform` (this) repo owns:

| Resource | Location | Notes |
|---|---|---|
| ESO controller Helm chart | `terraform/addons/external-secrets-operator/values-dev.yaml` | ArgoCD-managed |
| IRSA role | `terraform/environments/dev/api-service/eks-addons-irsa/` | Terraform-managed |
| ClusterSecretStore | `terraform/addons/external-secrets-operator/cluster-secret-store-dev.yaml` | Applied once after ESO is ready |

---

## App Deploy Repo Owns

Each application service repository owns its own `ExternalSecret` resources. The platform team does **not** create ExternalSecret manifests.

**ClusterSecretStore reference name**: `ssm-parameter-store`

**Example ExternalSecret:**
```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: api-core-secrets
  namespace: api-core
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: ssm-parameter-store
    kind: ClusterSecretStore
  target:
    name: api-core-secrets
    creationPolicy: Owner
  data:
    - secretKey: DB_PASSWORD
      remoteRef:
        key: /safespot/dev/api-core/db-password
    - secretKey: JWT_SECRET
      remoteRef:
        key: /safespot/dev/api-core/jwt-secret
```

---

## Secret Naming Convention

All secrets in AWS SSM Parameter Store follow this path convention:

```
/safespot/{environment}/{app}/{key}
```

| Application | Example Secret Path |
|---|---|
| api-core | `/safespot/dev/api-core/db-password` |
| api-core | `/safespot/dev/api-core/jwt-secret` |
| api-public-read | `/safespot/dev/api-public-read/db-password` |
| external-ingestion | `/safespot/dev/external-ingestion/webhook-secret` |
| async-worker | `/safespot/dev/async-worker/sqs-queue-url` |

Common secrets shared across services use the path prefix `/safespot/dev/common/`.

---

## ClusterSecretStore

The `ClusterSecretStore` named `ssm-parameter-store` is cluster-scoped and can be referenced from any namespace.

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: ssm-parameter-store
spec:
  provider:
    aws:
      service: ParameterStore
      region: ap-northeast-2
      auth:
        jwt:
          serviceAccountRef:
            name: external-secrets
            namespace: external-secrets
```

ESO uses the `external-secrets` service account in the `external-secrets` namespace for IRSA authentication. Do not delete or rename this service account.

---

## IRSA

ESO uses the IRSA role `safespot-dev-external-secrets-irsa` to read secrets from AWS.

**Permissions granted:**
- `ssm:GetParameter`, `ssm:GetParameters`, `ssm:GetParametersByPath` on all SSM Parameter Store resources

See `docs/irsa-contract.md` for the full IRSA binding details.

---

## Refresh Interval

The recommended `refreshInterval` for ExternalSecret resources is `1h`. For secrets that change frequently (e.g., short-lived credentials), use `5m`. Avoid `0s` (immediate) in production as it increases API call rate.

---

## Troubleshooting

```bash
# Check ESO controller logs
kubectl logs -n external-secrets -l app.kubernetes.io/name=external-secrets --tail=50

# Check ExternalSecret sync status
kubectl get externalsecret -A
kubectl describe externalsecret api-core-secrets -n api-core

# Verify ClusterSecretStore is ready
kubectl get clustersecretstore ssm-parameter-store

# Test secret access from AWS CLI
aws ssm get-parameter --name /safespot/dev/api-core/db-password --with-decryption
```
