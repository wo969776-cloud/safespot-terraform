# Karpenter

## Charts

| Chart | Source | Version | Managed by |
|---|---|---|---|
| Controller | `oci://public.ecr.aws/karpenter/karpenter` | 1.2.0 | `argocd/karpenter.yaml` (wave 1) |
| EC2NodeClass + NodePools | local `chart/` (this directory) | 0.1.0 | `argocd/karpenter-configs.yaml` (wave 2) |

## Controller IRSA

The controller IAM role is managed by Terraform (`eks-karpenter` environment). Run the init script after Terraform apply to populate the role ARN in `values-dev.yaml`:

```bash
bash scripts/init-addon-values.sh
```

Source: `terraform -chdir=terraform/environments/dev/api-service/eks-karpenter output -raw karpenter_controller_role_arn`

The service account **must** remain in `kube-system` — the OIDC trust policy is bound to that namespace (controlled by `var.karpenter_namespace` in `eks-karpenter` Terraform module).

| Resource | Value |
|---|---|
| Namespace | `kube-system` |
| Service Account | `karpenter` |
| Controller Role | `safespot-dev-karpenter-controller` |
| Node Role | `safespot-dev-karpenter-node` |
| Interruption Queue | see `values-dev.yaml` `settings.interruptionQueue` |

## Cluster Endpoint

Not set in `values-dev.yaml` — Karpenter v1.x auto-discovers the cluster endpoint from the EKS API when running in-cluster.

## Wrapper Chart (`chart/`)

EC2NodeClass and NodePools are defined as Helm templates inside `chart/`. Values are managed in `chart/values-dev.yaml`.

```
chart/
├── Chart.yaml
├── values.yaml          # defaults (all configurable fields documented here)
├── values-dev.yaml      # dev environment overrides
└── templates/
    ├── ec2nodeclass-default.yaml
    ├── nodepool-default.yaml
    └── nodepool-api-public-read.yaml
```

### Configurable values

| Field | Description | Source |
|---|---|---|
| `nodeClass.nodeRoleName` | IAM role name for Karpenter nodes | `eks-karpenter` output `karpenter_node_role_name` |
| `nodeClass.interruptionQueue` | SQS queue name (reference; must match controller `settings.interruptionQueue`) | `eks-karpenter` output `karpenter_queue_name` |
| `nodeClass.discovery.tagKey` | Tag key for subnet/SG selector | `karpenter.sh/discovery` |
| `nodeClass.discovery.tagValue` | Tag value — set to `<project>-<environment>` | From `terraform/modules/network/sg` |
| `nodeClass.subnetSelectorTerms` | Override full subnet selector (falls back to discovery tag) | — |
| `nodeClass.securityGroupSelectorTerms` | Override full SG selector (falls back to discovery tag) | — |
| `nodePools.default.requirements.*` | arch / os / capacityType / instanceCategory / instanceGeneration | — |
| `nodePools.apiPublicRead.requirements.*` | Same, for surge NodePool | — |

## Deployment

Both ArgoCD Applications are picked up automatically by `argocd/root-platform-addons.yaml` (app-of-apps).

```
Wave 1: argocd/karpenter.yaml          → Karpenter controller + CRD install
Wave 2: argocd/karpenter-configs.yaml  → EC2NodeClass + NodePool sync
```

No manual `kubectl apply` is required.
