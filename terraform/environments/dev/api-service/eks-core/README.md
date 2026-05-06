# eks-core

SafeSpot `dev` 환경의 EKS Core 인프라를 구성하는 Terraform root module입니다.

이 모듈은 내부 wrapper module인 `terraform/modules/api-service/eks-core`를 호출하여 EKS Cluster, 기본 Managed Node Group, 기본 EKS managed addons를 생성합니다.

---

## 1. 목적

`eks-core`는 SafeSpot 애플리케이션 서비스가 실행될 Kubernetes 기반 인프라의 최소 실행 기반을 구성합니다.

포함 범위는 다음과 같습니다.

- EKS Cluster
- EKS Cluster IAM Role
- EKS Cluster Security Group
- OIDC Provider
- 기본 EKS Managed Node Group
- 기본 EKS managed addons

---

## 2. 책임 범위

### 포함

| 영역               | 설명                                                                      |
| ------------------ | ------------------------------------------------------------------------- |
| EKS Cluster        | SafeSpot dev 환경용 Kubernetes Cluster 생성                               |
| Managed Node Group | 기본 always-on worker node group 생성                                     |
| EKS Addons         | `coredns`, `kube-proxy`, `vpc-cni`, `eks-pod-identity-agent` 구성         |
| OIDC Provider      | 이후 IRSA 또는 Pod Identity 연계를 위한 기반 제공                         |
| Outputs            | Karpenter, IRSA, Helm bootstrap 등 후속 모듈에서 사용할 cluster 정보 제공 |

### 제외

| 영역                         | 제외 사유                                     |
| ---------------------------- | --------------------------------------------- |
| Karpenter                    | 별도 `eks-karpenter` 모듈에서 관리            |
| IRSA 개별 Role               | 별도 `eks-irsa` 모듈에서 관리                 |
| AWS Load Balancer Controller | Helm/ArgoCD 또는 별도 bootstrap 단계에서 관리 |
| ArgoCD                       | EKS 생성 이후 bootstrap 단계에서 관리         |
| Prometheus / Grafana         | Observability Helm chart에서 관리             |
| Application Deployment       | Kubernetes manifest / Helm / ArgoCD에서 관리  |

---

## 3. 모듈 구조

```text
terraform/
├── environments/
│   └── dev/
│       └── api-service/
│           └── eks-core/
│               ├── backend.tf
│               ├── providers.tf
│               ├── versions.tf
│               ├── variables.tf
│               ├── main.tf
│               ├── outputs.tf
│               ├── terraform.tfvars
│               └── README.md
│
└── modules/
    └── api-service/
        └── eks-core/
            ├── versions.tf
            ├── variables.tf
            ├── main.tf
            ├── outputs.tf
            └── README.md
```

````

---

## 4. 사용 모듈

이 root module은 SafeSpot 내부 wrapper module을 호출합니다.

```hcl
module "eks_core" {
  source = "../../../../modules/api-service/eks-core"
}
```

wrapper module 내부에서는 다음 커뮤니티 모듈을 사용합니다.

```hcl
source  = "terraform-aws-modules/eks/aws"
version = "~> 20.0"
```

---

## 5. 버전 정책

| 항목         | 버전                     |
| ------------ | ------------------------ |
| Terraform    | `>= 1.6.0`               |
| AWS Provider | `>= 5.34, < 6.0`         |
| EKS Module   | `~> 20.0`                |
| Kubernetes   | `1.34`                   |
| Node AMI     | `AL2023_x86_64_STANDARD` |

EKS `1.34` 기준으로 Amazon Linux 2 기반 EKS Optimized AMI는 사용하지 않습니다. Managed Node Group은 AL2023 기준으로 구성합니다.

---

## 6. Backend

이 root module은 S3 backend를 사용합니다.

```hcl
terraform {
  backend "s3" {
    bucket = "safespot-terraform-state"
    key    = "environments/dev/api-service/eks-core/terraform.tfstate"
    region = "ap-northeast-2"
  }
}
```

State 경로:

```text
s3://safespot-terraform-state/environments/dev/api-service/eks-core/terraform.tfstate
```

---

## 7. 실행 순서

```bash
cd terraform/environments/dev/api-service/eks-core
```

```bash
terraform fmt -recursive
terraform init
terraform validate
terraform plan
```

적용 시:

```bash
terraform apply
```

---

## 8. AWS Profile 확인

Terraform 실행 전 현재 AWS 계정을 확인합니다.

```bash
aws sts get-caller-identity
```

특정 profile을 사용할 경우:

```bash
export AWS_PROFILE=<profile-name>
terraform init
terraform plan
```

---

## 9. 주요 입력값

| 변수                       | 설명                                     | 예시                       |
| -------------------------- | ---------------------------------------- | -------------------------- |
| `env`                      | 환경 이름                                | `dev`                      |
| `cluster_name`             | EKS Cluster 이름                         | `safespot-dev-eks`         |
| `cluster_version`          | Kubernetes 버전                          | `1.34`                     |
| `vpc_id`                   | EKS를 생성할 VPC ID                      | `vpc-xxxxxxxx`             |
| `private_subnet_ids`       | Worker Node가 위치할 private subnet 목록 | `["subnet-a", "subnet-b"]` |
| `control_plane_subnet_ids` | Control Plane ENI용 subnet 목록          | `["subnet-a", "subnet-b"]` |
| `node_instance_types`      | 기본 Node Group instance type            | `["t3.medium"]`            |
| `node_min_size`            | 최소 node 수                             | `1`                        |
| `node_max_size`            | 최대 node 수                             | `3`                        |
| `node_desired_size`        | 기본 desired node 수                     | `1`                        |

---

## 10. 주요 출력값

| 출력값                      | 용도                              |
| --------------------------- | --------------------------------- |
| `cluster_name`              | kubeconfig, 후속 모듈 참조        |
| `cluster_endpoint`          | EKS API endpoint 확인             |
| `cluster_security_group_id` | 보안 그룹 연계                    |
| `node_security_group_id`    | Node 보안 그룹 연계               |
| `oidc_provider`             | IRSA trust policy 구성            |
| `oidc_provider_arn`         | IRSA / Pod Identity 기반 IAM 구성 |
| `cluster_arn`               | AWS 리소스 식별 및 후속 연계      |

---

## 11. 검증 기준

`terraform plan` 결과에서 다음 리소스가 생성 대상에 포함되어야 합니다.

- EKS Cluster
- EKS Cluster IAM Role
- EKS Managed Node Group
- Node Group IAM Role
- EKS Addons
  - `coredns`
  - `kube-proxy`
  - `vpc-cni`
  - `eks-pod-identity-agent`

- OIDC Provider
- Security Groups / Security Group Rules

다음 리소스는 이 단계에서 생성되면 안 됩니다.

- Karpenter
- ArgoCD
- AWS Load Balancer Controller
- Prometheus
- Grafana
- Application Deployment 리소스

---

## 12. 주의사항

### Node Group 이름

Managed Node Group 이름은 짧게 유지합니다.

권장:

```hcl
name = "default"
```

비권장:

```hcl
name = "${var.cluster_name}-default"
```

Node Group 이름이 길어지면 내부 IAM Role `name_prefix` 길이 제한에 걸릴 수 있습니다.

---

### Provider Lock

AWS Provider v6가 `.terraform.lock.hcl`에 잠겨 있으면 다음 오류가 발생할 수 있습니다.

```text
locked provider registry.terraform.io/hashicorp/aws 6.x.x does not match configured version constraint < 6.0.0
```

해결:

```bash
terraform init -upgrade
```

필요 시:

```bash
rm -rf .terraform
rm -f .terraform.lock.hcl
terraform init
```

---

## 13. Network Remote State 소비 계약

`eks-core`는 `network` remote state에서 다음 값을 읽습니다.

| Output                  | 용도                                          |
| ----------------------- | --------------------------------------------- |
| `vpc_id`                | EKS Cluster VPC 지정                          |
| `private_app_subnet_ids`| Worker Node 배치 Subnet                      |
| `eks_cluster_sg_id`     | EKS Cluster Security Group (외부 생성본 사용) |
| `eks_node_sg_id`        | EKS Node Security Group (외부 생성본 사용)    |

EKS Cluster와 Node Group은 network module에서 미리 생성된 Security Group을 사용합니다. `eks-core`에서 Security Group을 새로 생성하지 않습니다.

### alb_sg_id 정책

`alb_sg_id`는 `network` module의 output을 source of truth로 사용합니다.

`eks-core`는 `alb_sg_id`를 pass-through output으로 재노출하지 않습니다.

Ingress Helm values에서 ALB Security Group이 필요한 경우 network remote state의 `alb_sg_id`를 직접 참조합니다.

```text
alb.ingress.kubernetes.io/security-groups: <network.outputs.alb_sg_id>
```

---

## 14. 후속 작업

`eks-core` 완료 후 다음 순서로 진행합니다.

```text
1. eks-irsa
2. eks-karpenter
3. EKS 운영 addon 또는 Helm bootstrap
4. ArgoCD bootstrap
5. Application Helm chart 배포
```

---

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.34, < 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_core"></a> [eks\_core](#module\_eks\_core) | ../../../../modules/api-service/eks-core | n/a |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.network](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region. | `string` | `"ap-northeast-2"` | no |
| <a name="input_cluster_endpoint_private_access"></a> [cluster\_endpoint\_private\_access](#input\_cluster\_endpoint\_private\_access) | Whether to expose EKS API endpoint privately. | `bool` | `true` | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Whether to expose EKS API endpoint publicly. | `bool` | `true` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name. | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes version for EKS. | `string` | `"1.34"` | no |
| <a name="input_eks_managed_node_group_name"></a> [eks\_managed\_node\_group\_name](#input\_eks\_managed\_node\_group\_name) | Name for the default EKS managed node group. | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment name. | `string` | n/a | yes |
| <a name="input_network_state_key"></a> [network\_state\_key](#input\_network\_state\_key) | S3 object key for network Terraform state. | `string` | `"environments/dev/network/terraform.tfstate"` | no |
| <a name="input_node_desired_size"></a> [node\_desired\_size](#input\_node\_desired\_size) | Desired node count. | `number` | `2` | no |
| <a name="input_node_iam_role_name"></a> [node\_iam\_role\_name](#input\_node\_iam\_role\_name) | IAM role name for EKS managed node group. | `string` | n/a | yes |
| <a name="input_node_instance_types"></a> [node\_instance\_types](#input\_node\_instance\_types) | Instance types for the default EKS managed node group. | `list(string)` | <pre>[<br/>  "t3.medium"<br/>]</pre> | no |
| <a name="input_node_max_size"></a> [node\_max\_size](#input\_node\_max\_size) | Maximum node count. | `number` | `3` | no |
| <a name="input_node_min_size"></a> [node\_min\_size](#input\_node\_min\_size) | Minimum node count. | `number` | `2` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name. | `string` | `"safespot"` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket name for Terraform remote state. | `string` | `"safespot-terraform-state"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | EKS cluster ARN. |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | EKS cluster endpoint. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | EKS cluster name. |
| <a name="output_cluster_primary_security_group_id"></a> [cluster\_primary\_security\_group\_id](#output\_cluster\_primary\_security\_group\_id) | EKS automatically-created cluster primary security group ID. |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | EKS cluster security group ID. |
| <a name="output_node_security_group_id"></a> [node\_security\_group\_id](#output\_node\_security\_group\_id) | EKS node security group ID. |
| <a name="output_oidc_provider"></a> [oidc\_provider](#output\_oidc\_provider) | OIDC provider URL without https:// prefix. |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | OIDC provider ARN. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

````
