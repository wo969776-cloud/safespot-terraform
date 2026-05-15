# eks-addons-irsa

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
| <a name="module_ebs_csi_irsa"></a> [ebs\_csi\_irsa](#module\_ebs\_csi\_irsa) | ../../../../modules/api-service/eks-irsa | n/a |
| <a name="module_external_dns_irsa"></a> [external\_dns\_irsa](#module\_external\_dns\_irsa) | ../../../../modules/api-service/eks-irsa | n/a |
| <a name="module_external_secrets_irsa"></a> [external\_secrets\_irsa](#module\_external\_secrets\_irsa) | ../../../../modules/api-service/eks-irsa | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.external_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.external_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [terraform_remote_state.eks_core](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | n/a | yes |
| <a name="input_ebs_csi_namespace"></a> [ebs\_csi\_namespace](#input\_ebs\_csi\_namespace) | Kubernetes namespace for AWS EBS CSI Driver | `string` | `"kube-system"` | no |
| <a name="input_ebs_csi_service_account_name"></a> [ebs\_csi\_service\_account\_name](#input\_ebs\_csi\_service\_account\_name) | Kubernetes service account name for AWS EBS CSI Driver controller | `string` | `"ebs-csi-controller-sa"` | no |
| <a name="input_eks_core_state_key"></a> [eks\_core\_state\_key](#input\_eks\_core\_state\_key) | S3 object key for EKS core Terraform state | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment name | `string` | n/a | yes |
| <a name="input_external_dns_namespace"></a> [external\_dns\_namespace](#input\_external\_dns\_namespace) | Kubernetes namespace for ExternalDNS | `string` | `"external-dns"` | no |
| <a name="input_external_dns_service_account_name"></a> [external\_dns\_service\_account\_name](#input\_external\_dns\_service\_account\_name) | Kubernetes service account name for ExternalDNS | `string` | `"external-dns"` | no |
| <a name="input_external_dns_zone_name"></a> [external\_dns\_zone\_name](#input\_external\_dns\_zone\_name) | Route53 public hosted zone name managed by ExternalDNS | `string` | `"safespot.site"` | no |
| <a name="input_external_secrets_namespace"></a> [external\_secrets\_namespace](#input\_external\_secrets\_namespace) | Kubernetes namespace for External Secrets Operator | `string` | `"external-secrets"` | no |
| <a name="input_external_secrets_service_account_name"></a> [external\_secrets\_service\_account\_name](#input\_external\_secrets\_service\_account\_name) | Kubernetes service account name for External Secrets Operator | `string` | `"external-secrets"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name | `string` | n/a | yes |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket name for Terraform remote state | `string` | `"safespot-terraform-state"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ebs_csi_irsa_role_arn"></a> [ebs\_csi\_irsa\_role\_arn](#output\_ebs\_csi\_irsa\_role\_arn) | ARN of the IRSA IAM role for AWS EBS CSI Driver |
| <a name="output_ebs_csi_irsa_role_name"></a> [ebs\_csi\_irsa\_role\_name](#output\_ebs\_csi\_irsa\_role\_name) | Name of the IRSA IAM role for AWS EBS CSI Driver |
| <a name="output_ebs_csi_service_account_subject"></a> [ebs\_csi\_service\_account\_subject](#output\_ebs\_csi\_service\_account\_subject) | OIDC subject for the AWS EBS CSI Driver service account |
| <a name="output_external_dns_irsa_role_arn"></a> [external\_dns\_irsa\_role\_arn](#output\_external\_dns\_irsa\_role\_arn) | ARN of the IRSA IAM role for ExternalDNS |
| <a name="output_external_dns_irsa_role_name"></a> [external\_dns\_irsa\_role\_name](#output\_external\_dns\_irsa\_role\_name) | Name of the IRSA IAM role for ExternalDNS |
| <a name="output_external_dns_policy_arn"></a> [external\_dns\_policy\_arn](#output\_external\_dns\_policy\_arn) | ARN of the IAM policy for ExternalDNS |
| <a name="output_external_dns_service_account_subject"></a> [external\_dns\_service\_account\_subject](#output\_external\_dns\_service\_account\_subject) | OIDC subject for the ExternalDNS service account |
| <a name="output_external_secrets_irsa_role_arn"></a> [external\_secrets\_irsa\_role\_arn](#output\_external\_secrets\_irsa\_role\_arn) | ARN of the IRSA IAM role for External Secrets Operator |
| <a name="output_external_secrets_irsa_role_name"></a> [external\_secrets\_irsa\_role\_name](#output\_external\_secrets\_irsa\_role\_name) | Name of the IRSA IAM role for External Secrets Operator |
| <a name="output_external_secrets_policy_arn"></a> [external\_secrets\_policy\_arn](#output\_external\_secrets\_policy\_arn) | ARN of the IAM policy for External Secrets Operator |
| <a name="output_external_secrets_service_account_subject"></a> [external\_secrets\_service\_account\_subject](#output\_external\_secrets\_service\_account\_subject) | OIDC subject for the External Secrets Operator service account |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
