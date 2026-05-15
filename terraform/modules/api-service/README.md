# api-service Terraform Modules

SafeSpot `dev` 환경의 API Service 인프라를 구성하는 Terraform 모듈 모음입니다.

---

## 모듈 구성

| 모듈            | 경로                                        | 설명                                         |
| --------------- | ------------------------------------------- | -------------------------------------------- |
| `eks-core`      | `modules/api-service/eks-core`              | EKS Cluster, Node Group, OIDC Provider       |
| `eks-irsa`      | `environments/dev/api-service/eks-irsa`     | ALB Controller IRSA Role/Policy              |
| `eks-karpenter` | `environments/dev/api-service/eks-karpenter`| Karpenter Controller/Node IAM, SQS Queue     |

---

## Network Remote State 소비

`eks-core`는 `network` remote state에서 다음 값을 사용합니다.

```text
- vpc_id
- private_app_subnet_ids
- eks_cluster_sg_id
- eks_node_sg_id
```

### alb_sg_id 정책

`alb_sg_id`는 `network` module의 output을 source of truth로 사용합니다.

`api-service`는 `alb_sg_id`를 pass-through output으로 재노출하지 않습니다.

Ingress Helm values에서 ALB Security Group이 필요한 경우 `network` remote state의 `alb_sg_id`를 직접 참조합니다.

```text
alb.ingress.kubernetes.io/security-groups: <network.outputs.alb_sg_id>
```

---

## Helm / Manifest 소비 Output 계약

아래 output을 Helm chart values 또는 Kubernetes manifest에서 참조합니다.

### ALB Controller

| Output                               | 용도                                            |
| ------------------------------------ | ----------------------------------------------- |
| `alb_controller_irsa_role_arn`       | ServiceAccount `eks.amazonaws.com/role-arn` annotation |
| `alb_controller_namespace`           | Helm values: `namespace`                        |
| `alb_controller_service_account_name`| Helm values: `serviceAccount.name`              |

### Karpenter

| Output                        | 용도                                                 |
| ----------------------------- | ---------------------------------------------------- |
| `karpenter_controller_role_arn` | ServiceAccount `eks.amazonaws.com/role-arn` annotation |
| `karpenter_node_role_name`    | `EC2NodeClass` spec.role                             |
| `karpenter_queue_name`        | Karpenter Helm settings.interruptionQueue            |

### EKS

| Output             | 용도                                       |
| ------------------ | ------------------------------------------ |
| `cluster_name`     | kubeconfig, Helm values                    |
| `cluster_endpoint` | EKS API endpoint                           |
| `cluster_arn`      | AWS 리소스 식별 및 후속 연계               |

---

## 네이밍 규칙

```text
{project}-{env}-{domain}-{resource_type}-{name}
```

예:

```text
safespot-dev-api-service-iam-role-alb-controller
safespot-dev-api-service-iam-policy-alb-controller
safespot-dev-api-service-iam-role-karpenter-controller
safespot-dev-api-service-iam-policy-karpenter-controller
safespot-dev-api-service-iam-role-karpenter-node
safespot-dev-api-service-sqs-karpenter
```

> **EKS cluster_name 주의**: `safespot-dev-eks` → `safespot-dev-api-service-eks-cluster` 변경은 리소스 replacement를 유발합니다. 실제 적용 전 별도 migration 판단이 필요합니다.

---

## 필수 태그

모든 리소스에 다음 태그가 포함되어야 합니다.

```hcl
common_tags = {
  Project     = var.project
  Environment = var.env
  Domain      = "api-service"
  Component   = "<module-name>"
  ManagedBy   = "terraform"
  Service     = var.project
  CostCenter  = "${var.project}-${var.env}"
}
```
