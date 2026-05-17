# eks-irsa

SafeSpot `dev` 환경의 EKS IRSA 구성을 관리하는 Terraform root module입니다.

이 모듈은 AWS API 접근 권한이 필요한 Kubernetes ServiceAccount에 IAM Role을 연결합니다.

---

## Responsibility

### Included

- IAM Policy per workload
- IRSA Role per workload
- IRSA trust policy
- IAM policy attachment
- Role ARN output

### Excluded

- AWS Load Balancer Controller Helm release
- Kubernetes ServiceAccount creation
- Ingress resource creation
- ALB/NLB resource creation
- Application deployment

---

## Current IRSA Targets

| Workload                     | Namespace     | ServiceAccount                 | AWS Permission                                                                 |
| ---------------------------- | ------------- | ------------------------------ | ------------------------------------------------------------------------------ |
| AWS Load Balancer Controller | `kube-system` | `aws-load-balancer-controller` | ALB/NLB 관리 정책                                                              |
| api-core                     | `application` | `api-core`                     | `sqs:SendMessage` → core event queue, scenario-simulator cache-refresh/readmodel-refresh queue |
| api-public-read              | `application` | `api-public-read`              | `sqs:SendMessage`, `sqs:GetQueueAttributes` → cache-refresh / readmodel-refresh / environment-cache-refresh |
| external-ingestion           | `application` | `external-ingestion`           | `sqs:SendMessage`, `sqs:GetQueueAttributes` → cache-refresh / readmodel-refresh / environment-cache-refresh |
| pre-scaling-controller       | `application` | `pre-scaling-controller`       | (AWS 권한 없음, K8s RBAC 전용)                                                 |

> **참고**: `api-public-read-surge`는 `serviceAccountName: api-public-read`를 재사용하므로 별도 IRSA 불필요.

---

## Helm Annotation Contract

The generated role ARN must be connected to the Kubernetes ServiceAccount annotation.

```yaml
serviceAccount:
  create: true
  name: aws-load-balancer-controller
  annotations:
    eks.amazonaws.com/role-arn: <alb_controller_irsa_role_arn>
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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_controller_irsa"></a> [alb\_controller\_irsa](#module\_alb\_controller\_irsa) | ../../../../modules/api-service/eks-irsa | n/a |
| <a name="module_api_core_irsa"></a> [api\_core\_irsa](#module\_api\_core\_irsa) | ../../../../modules/api-service/eks-irsa | n/a |
| <a name="module_api_public_read_irsa"></a> [api\_public\_read\_irsa](#module\_api\_public\_read\_irsa) | ../../../../modules/api-service/eks-irsa | n/a |
| <a name="module_external_ingestion_irsa"></a> [external\_ingestion\_irsa](#module\_external\_ingestion\_irsa) | ../../../../modules/api-service/eks-irsa | n/a |
| <a name="module_pre_scaling_controller_irsa"></a> [pre\_scaling\_controller\_irsa](#module\_pre\_scaling\_controller\_irsa) | ../../../../modules/api-service/eks-irsa | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.alb_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.api_core_sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.api_public_read_sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.external_ingestion_sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.api_core_sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.api_public_read_sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.external_ingestion_sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [terraform_remote_state.async_worker](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.eks_core](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_controller_namespace"></a> [alb\_controller\_namespace](#input\_alb\_controller\_namespace) | Kubernetes namespace for AWS Load Balancer Controller. | `string` | `"kube-system"` | no |
| <a name="input_alb_controller_service_account_name"></a> [alb\_controller\_service\_account\_name](#input\_alb\_controller\_service\_account\_name) | Kubernetes ServiceAccount name for AWS Load Balancer Controller. | `string` | `"aws-load-balancer-controller"` | no |
| <a name="input_api_core_service_account_name"></a> [api\_core\_service\_account\_name](#input\_api\_core\_service\_account\_name) | Kubernetes ServiceAccount name for api-core. | `string` | `"api-core"` | no |
| <a name="input_api_public_read_service_account_name"></a> [api\_public\_read\_service\_account\_name](#input\_api\_public\_read\_service\_account\_name) | Kubernetes ServiceAccount name for api-public-read. | `string` | `"api-public-read"` | no |
| <a name="input_app_namespace"></a> [app\_namespace](#input\_app\_namespace) | Kubernetes namespace for application pods. | `string` | `"application"` | no |
| <a name="input_async_worker_state_key"></a> [async\_worker\_state\_key](#input\_async\_worker\_state\_key) | S3 object key for async-worker Terraform state. | `string` | `"environments/dev/async-worker/terraform.tfstate"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region. | `string` | `"ap-northeast-2"` | no |
| <a name="input_eks_core_state_key"></a> [eks\_core\_state\_key](#input\_eks\_core\_state\_key) | S3 object key for eks-core Terraform state. | `string` | `"environments/dev/api-service/eks-core/terraform.tfstate"` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment name. | `string` | n/a | yes |
| <a name="input_external_ingestion_service_account_name"></a> [external\_ingestion\_service\_account\_name](#input\_external\_ingestion\_service\_account\_name) | Kubernetes ServiceAccount name for external-ingestion. | `string` | `"external-ingestion"` | no |
| <a name="input_pre_scaling_controller_service_account_name"></a> [pre\_scaling\_controller\_service\_account\_name](#input\_pre\_scaling\_controller\_service\_account\_name) | Kubernetes ServiceAccount name for pre-scaling-controller. | `string` | `"pre-scaling-controller"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name. | `string` | `"safespot"` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket name for Terraform remote state. | `string` | `"safespot-terraform-state"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_controller_irsa_role_arn"></a> [alb\_controller\_irsa\_role\_arn](#output\_alb\_controller\_irsa\_role\_arn) | IAM role ARN for AWS Load Balancer Controller IRSA. |
| <a name="output_alb_controller_irsa_role_name"></a> [alb\_controller\_irsa\_role\_name](#output\_alb\_controller\_irsa\_role\_name) | IAM role name for AWS Load Balancer Controller IRSA. |
| <a name="output_alb_controller_namespace"></a> [alb\_controller\_namespace](#output\_alb\_controller\_namespace) | Kubernetes namespace for AWS Load Balancer Controller. |
| <a name="output_alb_controller_policy_arn"></a> [alb\_controller\_policy\_arn](#output\_alb\_controller\_policy\_arn) | IAM policy ARN for AWS Load Balancer Controller. |
| <a name="output_alb_controller_service_account_name"></a> [alb\_controller\_service\_account\_name](#output\_alb\_controller\_service\_account\_name) | Kubernetes ServiceAccount name for AWS Load Balancer Controller. |
| <a name="output_alb_controller_service_account_subject"></a> [alb\_controller\_service\_account\_subject](#output\_alb\_controller\_service\_account\_subject) | Kubernetes service account subject for AWS Load Balancer Controller. |
| <a name="output_api_core_irsa_role_arn"></a> [api\_core\_irsa\_role\_arn](#output\_api\_core\_irsa\_role\_arn) | IAM role ARN for api-core IRSA. |
| <a name="output_api_core_irsa_service_account_subject"></a> [api\_core\_irsa\_service\_account\_subject](#output\_api\_core\_irsa\_service\_account\_subject) | Kubernetes service account subject for api-core IRSA trust policy. |
| <a name="output_api_public_read_irsa_role_arn"></a> [api\_public\_read\_irsa\_role\_arn](#output\_api\_public\_read\_irsa\_role\_arn) | IAM role ARN for api-public-read IRSA. |
| <a name="output_api_public_read_irsa_service_account_subject"></a> [api\_public\_read\_irsa\_service\_account\_subject](#output\_api\_public\_read\_irsa\_service\_account\_subject) | Kubernetes service account subject for api-public-read IRSA trust policy. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | EKS cluster name from eks-core remote state. |
| <a name="output_external_ingestion_irsa_role_arn"></a> [external\_ingestion\_irsa\_role\_arn](#output\_external\_ingestion\_irsa\_role\_arn) | IAM role ARN for external-ingestion IRSA. |
| <a name="output_external_ingestion_irsa_service_account_subject"></a> [external\_ingestion\_irsa\_service\_account\_subject](#output\_external\_ingestion\_irsa\_service\_account\_subject) | Kubernetes service account subject for external-ingestion IRSA trust policy. |
| <a name="output_pre_scaling_controller_irsa_role_arn"></a> [pre\_scaling\_controller\_irsa\_role\_arn](#output\_pre\_scaling\_controller\_irsa\_role\_arn) | IAM role ARN for pre-scaling-controller IRSA. |
| <a name="output_pre_scaling_controller_irsa_service_account_subject"></a> [pre\_scaling\_controller\_irsa\_service\_account\_subject](#output\_pre\_scaling\_controller\_irsa\_service\_account\_subject) | Kubernetes service account subject for pre-scaling-controller IRSA trust policy. |
| <a name="output_source_eks_core_state_key"></a> [source\_eks\_core\_state\_key](#output\_source\_eks\_core\_state\_key) | S3 state key used as eks-core remote state source. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
---
```
