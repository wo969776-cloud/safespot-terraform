# cicd

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cicd"></a> [cicd](#module\_cicd) | ../../../modules/ops/cicd | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [terraform_remote_state.ops](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_pull_request_oidc"></a> [allow\_pull\_request\_oidc](#input\_allow\_pull\_request\_oidc) | n/a | `bool` | `false` | no |
| <a name="input_allowed_branches"></a> [allowed\_branches](#input\_allowed\_branches) | n/a | `list(string)` | <pre>[<br/>  "main"<br/>]</pre> | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | n/a | yes |
| <a name="input_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#input\_cloudfront\_distribution\_id) | n/a | `string` | `""` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_ecr_push_repos"></a> [ecr\_push\_repos](#input\_ecr\_push\_repos) | ECR push 권한을 받을 repo 목록 (short name, org 제외) | `list(string)` | `[]` | no |
| <a name="input_ecr_repository_arns"></a> [ecr\_repository\_arns](#input\_ecr\_repository\_arns) | 비워두면 ops remote state에서 자동으로 읽음. 서비스명 → ARN map. | `map(string)` | `{}` | no |
| <a name="input_enable_terraform_apply"></a> [enable\_terraform\_apply](#input\_enable\_terraform\_apply) | n/a | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_frontend_deploy_repos"></a> [frontend\_deploy\_repos](#input\_frontend\_deploy\_repos) | Frontend S3/CloudFront 권한을 받을 repo 목록 (short name, org 제외) | `list(string)` | `[]` | no |
| <a name="input_frontend_s3_bucket"></a> [frontend\_s3\_bucket](#input\_frontend\_s3\_bucket) | n/a | `string` | `""` | no |
| <a name="input_github_org"></a> [github\_org](#input\_github\_org) | n/a | `string` | `"project-safespot"` | no |
| <a name="input_github_repos"></a> [github\_repos](#input\_github\_repos) | OIDC role을 생성할 repo 목록 (short name, org 제외) | `list(string)` | `[]` | no |
| <a name="input_lambda_deploy_repos"></a> [lambda\_deploy\_repos](#input\_lambda\_deploy\_repos) | Lambda code deploy 권한을 받을 repo 목록 (short name, org 제외) | `list(string)` | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `"safespot"` | no |
| <a name="input_ssm_kms_key_arn"></a> [ssm\_kms\_key\_arn](#input\_ssm\_kms\_key\_arn) | SSM SecureString KMS key ARN. 비워두면 CICD apply role에 KMS 권한을 부여하지 않습니다. | `string` | `""` | no |
| <a name="input_terraform_repos"></a> [terraform\_repos](#input\_terraform\_repos) | Terraform state 접근 권한을 받을 repo 목록 (short name, org 제외) | `list(string)` | `[]` | no |
| <a name="input_terraform_state_bucket"></a> [terraform\_state\_bucket](#input\_terraform\_state\_bucket) | n/a | `string` | n/a | yes |
| <a name="input_terraform_state_key_prefixes"></a> [terraform\_state\_key\_prefixes](#input\_terraform\_state\_key\_prefixes) | 비워두면 locals.tf의 환경별 기본 prefix 목록을 사용 | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_push_policy_arn"></a> [ecr\_push\_policy\_arn](#output\_ecr\_push\_policy\_arn) | n/a |
| <a name="output_github_actions_role_arns"></a> [github\_actions\_role\_arns](#output\_github\_actions\_role\_arns) | n/a |
| <a name="output_github_oidc_provider_arn"></a> [github\_oidc\_provider\_arn](#output\_github\_oidc\_provider\_arn) | n/a |
| <a name="output_terraform_infra_policy_arn"></a> [terraform\_infra\_policy\_arn](#output\_terraform\_infra\_policy\_arn) | n/a |
| <a name="output_terraform_state_policy_arn"></a> [terraform\_state\_policy\_arn](#output\_terraform\_state\_policy\_arn) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
