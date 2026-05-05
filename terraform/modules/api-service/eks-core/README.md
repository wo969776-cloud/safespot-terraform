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
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 20.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_endpoint_private_access"></a> [cluster\_endpoint\_private\_access](#input\_cluster\_endpoint\_private\_access) | Whether to expose EKS API endpoint privately. | `bool` | `true` | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Whether to enable public access to the EKS API endpoint. | `bool` | `true` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name. | `string` | n/a | yes |
| <a name="input_cluster_security_group_id"></a> [cluster\_security\_group\_id](#input\_cluster\_security\_group\_id) | Existing security group ID for EKS cluster. | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes version for EKS. | `string` | `"1.34"` | no |
| <a name="input_control_plane_subnet_ids"></a> [control\_plane\_subnet\_ids](#input\_control\_plane\_subnet\_ids) | Subnet IDs for EKS control plane ENIs. If empty, private\_subnet\_ids will be used. | `list(string)` | `[]` | no |
| <a name="input_eks_managed_node_group_name"></a> [eks\_managed\_node\_group\_name](#input\_eks\_managed\_node\_group\_name) | EKS managed node group name. | `string` | n/a | yes |
| <a name="input_node_desired_size"></a> [node\_desired\_size](#input\_node\_desired\_size) | Desired number of nodes in the default managed node group. | `number` | `2` | no |
| <a name="input_node_iam_role_name"></a> [node\_iam\_role\_name](#input\_node\_iam\_role\_name) | IAM role name for EKS managed node group. | `string` | n/a | yes |
| <a name="input_node_instance_types"></a> [node\_instance\_types](#input\_node\_instance\_types) | Instance types for the default EKS managed node group. | `list(string)` | <pre>[<br/>  "t3.medium"<br/>]</pre> | no |
| <a name="input_node_max_size"></a> [node\_max\_size](#input\_node\_max\_size) | Maximum number of nodes in the default managed node group. | `number` | `3` | no |
| <a name="input_node_min_size"></a> [node\_min\_size](#input\_node\_min\_size) | Minimum number of nodes in the default managed node group. | `number` | `2` | no |
| <a name="input_node_security_group_id"></a> [node\_security\_group\_id](#input\_node\_security\_group\_id) | Existing security group ID for EKS managed node group. | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for EKS managed node groups. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags for resources. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where the EKS cluster will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | EKS cluster ARN. |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | EKS cluster certificate authority data. |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | EKS cluster API endpoint. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | EKS cluster name. |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | EKS cluster security group ID. |
| <a name="output_eks_managed_node_groups"></a> [eks\_managed\_node\_groups](#output\_eks\_managed\_node\_groups) | EKS managed node group outputs. |
| <a name="output_node_security_group_id"></a> [node\_security\_group\_id](#output\_node\_security\_group\_id) | EKS node security group ID. |
| <a name="output_oidc_provider"></a> [oidc\_provider](#output\_oidc\_provider) | OIDC provider URL without https:// prefix. |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | OIDC provider ARN. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
