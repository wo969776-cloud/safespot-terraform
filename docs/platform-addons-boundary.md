# Platform Addons Boundary: Terraform vs ArgoCD

This document defines the ownership boundary between Terraform (AWS infrastructure and IAM) and ArgoCD (Kubernetes workload management) for the SafeSpot platform.

---

## Terraform Responsibility

Terraform is responsible for all AWS-level resources and the Kubernetes cluster bootstrap. It does **not** install Helm charts or apply Kubernetes manifests beyond what is necessary for cluster operation.

### eks-core

State key: `environments/dev/api-service/eks-core/terraform.tfstate`

- EKS cluster provisioning (control plane, managed node groups)
- VPC, subnets, security groups (referenced from network state)
- OIDC provider for IRSA
- EKS managed addons: `coredns`, `kube-proxy`, `vpc-cni`, `aws-ebs-csi-driver`
- Cluster access entries and RBAC bootstrap
- Outputs: `cluster_name`, `cluster_endpoint`, `oidc_provider_arn`, `oidc_provider`, `vpc_id`

### eks-karpenter

State key: `environments/dev/api-service/eks-karpenter/terraform.tfstate`

- Karpenter controller IAM role (`safespot-dev-karpenter-controller`) with IRSA trust policy bound to `kube-system/karpenter`
- Karpenter node IAM role (`safespot-dev-karpenter-node`)
- SQS interruption queue (`safespot-dev-karpenter`)
- EventBridge rules for spot interruption events

### eks-irsa

State key: `environments/dev/api-service/eks-irsa/terraform.tfstate`

- ALB Controller IAM policy (`safespot-dev-aws-load-balancer-controller-irsa`)
- ALB Controller IRSA role bound to `kube-system/aws-load-balancer-controller`

### eks-addons-irsa

State key: `environments/dev/api-service/eks-addons-irsa/terraform.tfstate`

- ExternalDNS IAM policy and IRSA role (`safespot-dev-external-dns-irsa`) bound to `external-dns/external-dns`
- External Secrets Operator IAM policy and IRSA role (`safespot-dev-external-secrets-irsa`) bound to `external-secrets/external-secrets`

---

## ArgoCD Responsibility

ArgoCD is responsible for installing and reconciling Helm charts and Kubernetes manifests inside the cluster. It does **not** create AWS resources.

ArgoCD reads Helm values from this repository (`safespot-terraform`) via multi-source Applications and installs charts from their respective upstream repositories.

| Application | Chart | Namespace | Sync Wave |
|---|---|---|---|
| `cert-manager` | charts.jetstack.io/cert-manager v1.16.0 | `cert-manager` | 0 |
| `aws-load-balancer-controller` | aws.github.io/eks-charts v1.9.2 | `kube-system` | 1 |
| `karpenter` | public.ecr.aws/karpenter v1.2.0 | `kube-system` | 1 |
| `external-secrets-operator` | charts.external-secrets.io v0.11.0 | `external-secrets` | 1 |
| `metrics-server` | kubernetes-sigs.github.io/metrics-server v3.12.2 | `kube-system` | 1 |
| `karpenter-configs` | local `terraform/addons/karpenter/chart` (wrapper) | `kube-system` | 2 |
| `eso-configs` | local `terraform/addons/external-secrets-operator/chart` (wrapper) | `external-secrets` | 2 |
| `external-dns` | kubernetes-sigs.github.io/external-dns v1.15.0 | `external-dns` | 2 |

`karpenter-configs` installs EC2NodeClass and NodePool via a local wrapper Helm chart (`terraform/addons/karpenter/chart/`). `eso-configs` installs ClusterSecretStore via a local wrapper Helm chart (`terraform/addons/external-secrets-operator/chart/`). All configuration is managed through each chart's `values-dev.yaml`. No manual `kubectl apply` is needed.

---

## App Deploy Repo Responsibility

Each application service repository (api-core, api-public-read, external-ingestion, async-worker) owns:

- `Deployment` and `Service` manifests for the application
- `Ingress` (with ALB annotations and hostname for ExternalDNS)
- `HorizontalPodAutoscaler` (uses Metrics Server)
- `ExternalSecret` (references `ClusterSecretStore: aws-secrets-manager`)
- `PodDisruptionBudget`
- `nodeSelector` and `tolerations` aligned to Karpenter NodePool contracts (see `docs/karpenter-nodepool-contract.md`)

App deploy repos do **not** manage IRSA roles, IAM policies, or any AWS resources.

---

## Observability Repo Responsibility

A separate observability repository owns:

- `kube-prometheus-stack` Helm release (Prometheus, Alertmanager, Grafana)
- `ServiceMonitor` resources for scraping application pods
- `PrometheusRule` resources for alerting
- Grafana dashboards (ConfigMaps)
- Log aggregation configuration (e.g., Fluent Bit, OpenTelemetry Collector)

The observability repo does **not** manage application deployments or platform addon charts.
