# cicd

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.44.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.ecr_push](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.frontend_deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.lambda_deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.terraform_infra](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecr_push](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.frontend_deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.terraform_infra](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | n/a | `string` | n/a | yes |
| <a name="input_allow_pull_request_oidc"></a> [allow\_pull\_request\_oidc](#input\_allow\_pull\_request\_oidc) | n/a | `bool` | `false` | no |
| <a name="input_allowed_branches"></a> [allowed\_branches](#input\_allowed\_branches) | n/a | `list(string)` | <pre>[<br/>  "main"<br/>]</pre> | no |
| <a name="input_allowed_github_environments"></a> [allowed\_github\_environments](#input\_allowed\_github\_environments) | OIDC trust policy??허용할 GitHub Environment 이름 목록 | `list(string)` | `[]` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | n/a | yes |
| <a name="input_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#input\_cloudfront\_distribution\_id) | n/a | `string` | `""` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | n/a | `map(string)` | n/a | yes |
| <a name="input_ecr_push_repos"></a> [ecr\_push\_repos](#input\_ecr\_push\_repos) | ECR push 권한을 부여할 repo 목록 (short name, org 제외) | `list(string)` | `[]` | no |
| <a name="input_ecr_repository_arns"></a> [ecr\_repository\_arns](#input\_ecr\_repository\_arns) | ECR repository ARN map. 서비스명 → ARN 형태. ops remote state ecr\_repository\_arns output과 동일한 구조. | `map(string)` | n/a | yes |
| <a name="input_enable_terraform_apply"></a> [enable\_terraform\_apply](#input\_enable\_terraform\_apply) | n/a | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_frontend_deploy_repos"></a> [frontend\_deploy\_repos](#input\_frontend\_deploy\_repos) | Frontend S3/CloudFront 권한을 부여할 repo 목록 (short name, org 제외) | `list(string)` | `[]` | no |
| <a name="input_frontend_s3_bucket"></a> [frontend\_s3\_bucket](#input\_frontend\_s3\_bucket) | n/a | `string` | `""` | no |
| <a name="input_github_org"></a> [github\_org](#input\_github\_org) | n/a | `string` | `"project-safespot"` | no |
| <a name="input_github_repos"></a> [github\_repos](#input\_github\_repos) | n/a | `list(string)` | <pre>[<br/>  "safespot-applicaton",<br/>  "safespot-front"<br/>]</pre> | no |
| <a name="input_lambda_deploy_repos"></a> [lambda\_deploy\_repos](#input\_lambda\_deploy\_repos) | Lambda code deploy 권한을 부여할 repo 목록 (short name, org 제외) | `list(string)` | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `"safespot"` | no |
| <a name="input_ssm_kms_key_arn"></a> [ssm\_kms\_key\_arn](#input\_ssm\_kms\_key\_arn) | KMS key ARN for SSM SecureString. 비워두면 KMS 권한 statement를 생성하지 않습니다. | `string` | `""` | no |
| <a name="input_terraform_repos"></a> [terraform\_repos](#input\_terraform\_repos) | Terraform state 접근 권한을 부여할 repo 목록 (short name, org 제외) | `list(string)` | `[]` | no |
| <a name="input_terraform_state_bucket"></a> [terraform\_state\_bucket](#input\_terraform\_state\_bucket) | n/a | `string` | n/a | yes |
| <a name="input_terraform_state_key_prefixes"></a> [terraform\_state\_key\_prefixes](#input\_terraform\_state\_key\_prefixes) | n/a | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_push_policy_arn"></a> [ecr\_push\_policy\_arn](#output\_ecr\_push\_policy\_arn) | n/a |
| <a name="output_github_actions_role_arns"></a> [github\_actions\_role\_arns](#output\_github\_actions\_role\_arns) | n/a |
| <a name="output_github_oidc_provider_arn"></a> [github\_oidc\_provider\_arn](#output\_github\_oidc\_provider\_arn) | n/a |
| <a name="output_terraform_infra_policy_arn"></a> [terraform\_infra\_policy\_arn](#output\_terraform\_infra\_policy\_arn) | n/a |
| <a name="output_terraform_state_policy_arn"></a> [terraform\_state\_policy\_arn](#output\_terraform\_state\_policy\_arn) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
