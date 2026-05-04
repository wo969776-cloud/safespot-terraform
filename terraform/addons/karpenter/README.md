# Karpenter

## Chart

- **Repository**: `oci://public.ecr.aws/karpenter/karpenter` (OCI registry)
- **Chart Version**: 1.2.0
- **API Version**: karpenter.sh/v1 / karpenter.k8s.aws/v1

## IRSA

The controller IAM role is managed by Terraform (`eks-karpenter` environment). Run the init script after Terraform apply to populate the role ARN in `values-dev.yaml`:

```bash
bash scripts/init-addon-values.sh
```

Source: `terraform -chdir=terraform/environments/dev/api-service/eks-karpenter output -raw karpenter_controller_role_arn`

The service account **must** remain in `kube-system` — this is where the OIDC trust policy is bound (controlled by `var.karpenter_namespace` in `eks-karpenter` Terraform module).

| Resource | Value |
|---|---|
| Namespace | `kube-system` |
| Service Account | `karpenter` |
| Controller Role | `safespot-dev-karpenter-controller` |
| Node Role | `safespot-dev-karpenter-node` |
| Interruption Queue | `safespot-dev-karpenter` |

## Cluster Endpoint

Not set in `values-dev.yaml` — Karpenter v1.x auto-discovers the cluster endpoint from the EKS API when running in-cluster.

## Manifests

| File | Description |
|---|---|
| `nodepool-default.yaml` | Default NodePool for general workloads (spot + on-demand, label `role=workload`) |
| `nodepool-api-public-read.yaml` | NodePool for api-public-read surge traffic (spot only, taint `workload=api-public-read:NoSchedule`) |
| `ec2nodeclass-default.yaml` | EC2NodeClass with AL2023, subnet/SG selected by cluster tag |

## Deployment

Deployed via ArgoCD. See `argocd/karpenter.yaml`. Apply NodePool and EC2NodeClass **after** Karpenter is running:

```bash
kubectl apply -f terraform/addons/karpenter/ec2nodeclass-default.yaml
kubectl apply -f terraform/addons/karpenter/nodepool-default.yaml
kubectl apply -f terraform/addons/karpenter/nodepool-api-public-read.yaml
```
