<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.34, < 6.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_karpenter"></a> [karpenter](#module\_karpenter) | terraform-aws-modules/eks/aws//modules/karpenter | ~> 20.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name. | `string` | n/a | yes |
| <a name="input_controller_policy_name"></a> [controller\_policy\_name](#input\_controller\_policy\_name) | IAM policy name for Karpenter controller. | `string` | n/a | yes |
| <a name="input_controller_role_name"></a> [controller\_role\_name](#input\_controller\_role\_name) | IAM role name for Karpenter controller. | `string` | n/a | yes |
| <a name="input_enable_spot_termination"></a> [enable\_spot\_termination](#input\_enable\_spot\_termination) | Whether to enable native spot interruption handling. | `bool` | `true` | no |
| <a name="input_enable_v1_permissions"></a> [enable\_v1\_permissions](#input\_enable\_v1\_permissions) | Whether to enable Karpenter v1+ IAM permissions. | `bool` | `true` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace for Karpenter controller. | `string` | `"kube-system"` | no |
| <a name="input_node_iam_role_additional_policies"></a> [node\_iam\_role\_additional\_policies](#input\_node\_iam\_role\_additional\_policies) | Additional IAM policies to attach to Karpenter node IAM role. | `map(string)` | `{}` | no |
| <a name="input_node_role_name"></a> [node\_role\_name](#input\_node\_role\_name) | IAM role name for Karpenter provisioned nodes. | `string` | n/a | yes |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | EKS OIDC provider ARN for Karpenter IRSA. | `string` | n/a | yes |
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | SQS queue name for Karpenter interruption handling. | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Kubernetes ServiceAccount name for Karpenter controller. | `string` | `"karpenter"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_controller_role_arn"></a> [controller\_role\_arn](#output\_controller\_role\_arn) | Karpenter controller IAM role ARN. |
| <a name="output_controller_role_name"></a> [controller\_role\_name](#output\_controller\_role\_name) | Karpenter controller IAM role name. |
| <a name="output_instance_profile_name"></a> [instance\_profile\_name](#output\_instance\_profile\_name) | Karpenter node instance profile name. |
| <a name="output_node_role_arn"></a> [node\_role\_arn](#output\_node\_role\_arn) | Karpenter node IAM role ARN. |
| <a name="output_node_role_name"></a> [node\_role\_name](#output\_node\_role\_name) | Karpenter node IAM role name. |
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | Karpenter interruption queue ARN. |
| <a name="output_queue_name"></a> [queue\_name](#output\_queue\_name) | Karpenter interruption queue name. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
