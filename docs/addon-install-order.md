# Platform Addon Install Order

This document defines the correct installation sequence for the SafeSpot dev environment. Following this order prevents dependency failures between Terraform-provisioned AWS resources and ArgoCD-managed Kubernetes workloads.

---

## Phase 1: Terraform Apply

Apply Terraform modules in dependency order. Each step must complete successfully before proceeding.

```
VPC / Network
  └── EKS Cluster (eks-core)
        ├── OIDC Provider (created by eks-core)
        ├── EKS Managed Addons (coredns, kube-proxy, vpc-cni, aws-ebs-csi-driver)
        ├── IRSA Roles
        │     ├── eks-irsa       → ALB Controller role
        │     └── eks-addons-irsa → ExternalDNS role, ESO role
        └── Karpenter IAM (eks-karpenter)
              ├── Karpenter controller role
              ├── Karpenter node role
              └── SQS interruption queue

Route53 Hosted Zone (front-edge or standalone)
SSM Parameter Store secrets (initial secret creation)
SSM Parameters (ssm-parameters)
```

**Terraform apply commands (in order):**

```bash
# 1. Network
cd terraform/environments/dev/network && terraform apply

# 2. EKS core
cd terraform/environments/dev/api-service/eks-core && terraform apply

# 3. Karpenter IAM
cd terraform/environments/dev/api-service/eks-karpenter && terraform apply

# 4. ALB Controller IRSA
cd terraform/environments/dev/api-service/eks-irsa && terraform apply

# 5. ExternalDNS + ESO IRSA
cd terraform/environments/dev/api-service/eks-addons-irsa && terraform apply

# 6. Route53 / ACM (if applicable)
cd terraform/environments/dev/front-edge && terraform apply

# 7. SSM Parameters
cd terraform/environments/dev/ssm-parameters && terraform apply
```

---

## Phase 2: ArgoCD Bootstrap

Install ArgoCD into the cluster before syncing any applications.

```bash
# Create argocd namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=120s

# Apply the app-of-apps root application
kubectl apply -f argocd/root-platform-addons.yaml
```

---

## Phase 3: Platform Addon Sync

ArgoCD sync-waves control the order. Apps with lower wave numbers sync first.

| Wave | Application | Notes |
|---|---|---|
| 0 | cert-manager | CRD installation first; optional for ACM-based TLS |
| 1 | aws-load-balancer-controller | Requires IRSA role from eks-irsa |
| 1 | karpenter | Requires IRSA roles and SQS queue from eks-karpenter |
| 1 | external-secrets-operator | Requires IRSA role from eks-addons-irsa |
| 1 | metrics-server | No IRSA required |
| 2 | karpenter-configs | EC2NodeClass + NodePool via wrapper chart; requires Karpenter CRDs (wave 1) |
| 2 | eso-configs | ClusterSecretStore via wrapper chart; requires ESO CRDs (wave 1) |
| 2 | external-dns | Requires IRSA role from eks-addons-irsa; depends on ALB Controller being ready |

Karpenter EC2NodeClass/NodePools and ESO ClusterSecretStore are both managed by ArgoCD (wave 2 wrapper charts). No manual `kubectl apply` is needed.

---

## Phase 4: App Deploy Repo Sync

Deploy application services after platform addons are healthy. Each application is managed by its own ArgoCD Application in the app deploy repo.

| Order | Service | Notes |
|---|---|---|
| 1 | api-core | Core API service |
| 2 | api-public-read | Read-optimized API; uses `api-public-read` NodePool |
| 3 | external-ingestion | External data ingestion service |
| 4 | async-worker | Background job processor |

Prerequisites before app deploy:
- ALB Controller is running (for Ingress provisioning)
- ExternalDNS is running (for DNS record creation)
- ESO + ClusterSecretStore is running (for ExternalSecret resolution)
- Karpenter NodePools are applied (for workload node provisioning)

---

## Phase 5: Observability Repo Sync

Deploy the observability stack after application services are running.

| Order | Component | Notes |
|---|---|---|
| 1 | kube-prometheus-stack | Prometheus, Alertmanager, Grafana |
| 2 | ServiceMonitor resources | One per application service |
| 3 | PrometheusRule resources | Alerting rules per service |
| 4 | Grafana Dashboards | ConfigMap-based dashboard imports |
