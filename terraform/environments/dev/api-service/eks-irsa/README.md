# eks-irsa

SafeSpot `dev` 환경의 EKS IRSA 구성을 관리하는 Terraform root module입니다.

이 모듈은 AWS API 접근 권한이 필요한 Kubernetes ServiceAccount에 IAM Role을 연결합니다.

현재 1차 대상은 AWS Load Balancer Controller입니다.

---

## Responsibility

### Included

- AWS Load Balancer Controller IAM Policy
- AWS Load Balancer Controller IRSA Role
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

| Workload                     | Namespace     | ServiceAccount                 | Purpose                           |
| ---------------------------- | ------------- | ------------------------------ | --------------------------------- |
| AWS Load Balancer Controller | `kube-system` | `aws-load-balancer-controller` | Manage ALB/NLB resources from EKS |

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

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.alb_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [terraform_remote_state.eks_core](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_controller_namespace"></a> [alb\_controller\_namespace](#input\_alb\_controller\_namespace) | Kubernetes namespace for AWS Load Balancer Controller. | `string` | `"kube-system"` | no |
| <a name="input_alb_controller_service_account_name"></a> [alb\_controller\_service\_account\_name](#input\_alb\_controller\_service\_account\_name) | Kubernetes ServiceAccount name for AWS Load Balancer Controller. | `string` | `"aws-load-balancer-controller"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region. | `string` | `"ap-northeast-2"` | no |
| <a name="input_eks_core_state_key"></a> [eks\_core\_state\_key](#input\_eks\_core\_state\_key) | S3 object key for eks-core Terraform state. | `string` | `"environments/dev/api-service/eks-core/terraform.tfstate"` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment name. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name. | `string` | `"safespot"` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket name for Terraform remote state. | `string` | `"safespot-terraform-state"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_controller_irsa_role_arn"></a> [alb\_controller\_irsa\_role\_arn](#output\_alb\_controller\_irsa\_role\_arn) | IAM role ARN for AWS Load Balancer Controller IRSA. |
| <a name="output_alb_controller_irsa_role_name"></a> [alb\_controller\_irsa\_role\_name](#output\_alb\_controller\_irsa\_role\_name) | IAM role name for AWS Load Balancer Controller IRSA. |
| <a name="output_alb_controller_policy_arn"></a> [alb\_controller\_policy\_arn](#output\_alb\_controller\_policy\_arn) | IAM policy ARN for AWS Load Balancer Controller. |
| <a name="output_alb_controller_service_account_subject"></a> [alb\_controller\_service\_account\_subject](#output\_alb\_controller\_service\_account\_subject) | Kubernetes service account subject for AWS Load Balancer Controller. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | EKS cluster name from eks-core remote state. |
| <a name="output_source_eks_core_state_key"></a> [source\_eks\_core\_state\_key](#output\_source\_eks\_core\_state\_key) | S3 state key used as eks-core remote state source. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
---
```
