# modules/ssm-parameters

SSM Parameter Store 리소스를 생성하는 재사용 가능 Terraform 모듈입니다.

---

## 개요

`/{project}/{env}/{key}` 형태로 SSM Parameter name을 일관되게 생성합니다.

```hcl
name = "/${var.project}/${var.env}/${each.key}"
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
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | n/a | `string` | `null` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | n/a | <pre>map(object({<br/>    value       = string<br/>    type        = string<br/>    description = optional(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | n/a | yes |
| <a name="input_use_custom_kms_key"></a> [use\_custom\_kms\_key](#input\_use\_custom\_kms\_key) | n/a | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_parameter_arns"></a> [parameter\_arns](#output\_parameter\_arns) | n/a |
| <a name="output_parameter_name_prefix"></a> [parameter\_name\_prefix](#output\_parameter\_name\_prefix) | SSM parameter path prefix. |
| <a name="output_parameter_names"></a> [parameter\_names](#output\_parameter\_names) | n/a |
| <a name="output_secure_parameter_names"></a> [secure\_parameter\_names](#output\_secure\_parameter\_names) | n/a |
| <a name="output_string_parameter_names"></a> [string\_parameter\_names](#output\_string\_parameter\_names) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
