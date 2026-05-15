# eks-karpenter

SafeSpot `dev` 환경의 Karpenter 기반 AWS 리소스를 구성하는 Terraform root module입니다.

이 모듈은 `eks-core` remote state를 참조하여 Karpenter Controller와 Karpenter가 생성할 Node에 필요한 IAM/SQS/EventBridge 기반 리소스를 구성합니다.

---

## Responsibility

### Included

- Karpenter Controller IAM Role
- Karpenter Controller IAM Policy
- Karpenter Node IAM Role
- Karpenter Node Instance Profile
- Karpenter interruption SQS queue
- EventBridge rules
- EKS Access Entry for Karpenter node role

### Excluded

- Karpenter Helm release
- Karpenter Controller Pod
- NodePool
- EC2NodeClass
- Application workload scheduling policy

---

## Remote State Dependency

This module depends on `eks-core`.

```text
s3://safespot-terraform-state/environments/dev/api-service/eks-core/terraform.tfstate
```

---

## Required outputs:

- cluster_name
- oidc_provider_arn

---

## Helm Annotation Contract

- Karpenter Helm chart must use the generated controller role ARN.

```yaml
serviceAccount:
  create: true
  name: karpenter
  annotations:
    eks.amazonaws.com/role-arn: <karpenter_controller_role_arn>
```

---

## Execution Order

1. network apply
2. eks-core apply
3. eks-karpenter plan/apply
4. Karpenter Helm install
5. NodePool / EC2NodeClass apply

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
| <a name="module_eks_karpenter"></a> [eks\_karpenter](#module\_eks\_karpenter) | ../../../../modules/api-service/eks-karpenter | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [terraform_remote_state.eks_core](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region. | `string` | `"ap-northeast-2"` | no |
| <a name="input_eks_core_state_key"></a> [eks\_core\_state\_key](#input\_eks\_core\_state\_key) | S3 object key for eks-core Terraform state. | `string` | `"environments/dev/api-service/eks-core/terraform.tfstate"` | no |
| <a name="input_enable_spot_termination"></a> [enable\_spot\_termination](#input\_enable\_spot\_termination) | Whether to enable native spot interruption handling. | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment name. | `string` | n/a | yes |
| <a name="input_karpenter_namespace"></a> [karpenter\_namespace](#input\_karpenter\_namespace) | Kubernetes namespace for Karpenter controller. | `string` | `"kube-system"` | no |
| <a name="input_karpenter_service_account_name"></a> [karpenter\_service\_account\_name](#input\_karpenter\_service\_account\_name) | Kubernetes ServiceAccount name for Karpenter controller. | `string` | `"karpenter"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name. | `string` | `"safespot"` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket name for Terraform remote state. | `string` | `"safespot-terraform-state"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | EKS cluster name from eks-core remote state. |
| <a name="output_karpenter_controller_role_arn"></a> [karpenter\_controller\_role\_arn](#output\_karpenter\_controller\_role\_arn) | Karpenter controller IAM role ARN. |
| <a name="output_karpenter_controller_role_name"></a> [karpenter\_controller\_role\_name](#output\_karpenter\_controller\_role\_name) | Karpenter controller IAM role name. |
| <a name="output_karpenter_instance_profile_name"></a> [karpenter\_instance\_profile\_name](#output\_karpenter\_instance\_profile\_name) | Karpenter node instance profile name. |
| <a name="output_karpenter_node_role_arn"></a> [karpenter\_node\_role\_arn](#output\_karpenter\_node\_role\_arn) | Karpenter node IAM role ARN. |
| <a name="output_karpenter_node_role_name"></a> [karpenter\_node\_role\_name](#output\_karpenter\_node\_role\_name) | Karpenter node IAM role name. |
| <a name="output_karpenter_queue_arn"></a> [karpenter\_queue\_arn](#output\_karpenter\_queue\_arn) | Karpenter interruption queue ARN. |
| <a name="output_karpenter_queue_name"></a> [karpenter\_queue\_name](#output\_karpenter\_queue\_name) | Karpenter interruption queue name. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

---

```

```
