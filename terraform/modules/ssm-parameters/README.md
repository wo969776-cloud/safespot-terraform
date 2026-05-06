# modules/ssm-parameters

비민감 SSM `String` Parameter만 생성하는 재사용 Terraform 모듈이다.

이 모듈은 `SecureString`, KMS key, secret value를 생성하거나 관리하지 않는다. Parameter name은 호출자가 완성된 경로로 전달한다.

```hcl
module "ssm_parameters" {
  source = "../../../modules/ssm-parameters"

  parameters = {
    app_profile = {
      name        = "/safespot/dev/app/profile"
      value       = "dev"
      description = "SafeSpot runtime profile."
    }
  }
}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.34, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.43.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_parameters"></a> [parameters](#input\_parameters) | Non-sensitive SSM String parameters. | <pre>map(object({<br/>    name        = string<br/>    value       = string<br/>    description = optional(string)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_parameter_arns"></a> [parameter\_arns](#output\_parameter\_arns) | Created SSM parameter ARNs. |
| <a name="output_parameter_names"></a> [parameter\_names](#output\_parameter\_names) | Created SSM parameter names. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
