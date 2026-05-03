# ssm-parameters

SafeSpot `dev` 환경의 SSM Parameter Store 관리 Terraform root module입니다.

---

## 개요

이 모듈은 `/{project}/{env}/{key}` 형태로 SSM Parameter name을 생성합니다.

예:

```text
/safespot/dev/common/aws-region
/safespot/dev/common/spring-profile
/safespot/dev/data/aurora-cluster-endpoint
/safespot/dev/data/aurora-reader-endpoint
/safespot/dev/data/aurora-port
/safespot/dev/data/aurora-db-name
/safespot/dev/data/redis-primary-endpoint
/safespot/dev/data/redis-reader-endpoint
/safespot/dev/data/redis-port
```

---

## Data Remote State 소비

`data` module의 remote state를 읽어 RDS/Redis endpoint 정보를 SSM Parameter로 자동 등록합니다.

| Data Output                | SSM Parameter Key              |
| -------------------------- | ------------------------------ |
| `aurora_cluster_endpoint`  | `data/aurora-cluster-endpoint` |
| `aurora_reader_endpoint`   | `data/aurora-reader-endpoint`  |
| `aurora_port`              | `data/aurora-port`             |
| `aurora_db_name`           | `data/aurora-db-name`          |
| `redis_primary_endpoint`   | `data/redis-primary-endpoint`  |
| `redis_reader_endpoint`    | `data/redis-reader-endpoint`   |
| `redis_port`               | `data/redis-port`              |

`data` remote state가 준비된 이후 `terraform plan` / `terraform apply`를 수행합니다.

---

## 태그 규칙

```hcl
common_tags = {
  Project     = var.project
  Environment = var.env
  Domain      = "ssm-parameters"
  ManagedBy   = "terraform"
  Service     = var.project
  CostCenter  = "${var.project}-${var.env}"
}
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
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ssm_parameters"></a> [ssm\_parameters](#module\_ssm\_parameters) | ../../../modules/ssm-parameters | n/a |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.data](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | n/a | yes |
| <a name="input_data_state_key"></a> [data\_state\_key](#input\_data\_state\_key) | S3 object key for data Terraform state. | `string` | `"environments/dev/data/terraform.tfstate"` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment name | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name | `string` | n/a | yes |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket name for Terraform remote state. | `string` | `"safespot-terraform-state"` | no |
| <a name="input_ssm_parameters"></a> [ssm\_parameters](#input\_ssm\_parameters) | SSM parameters to create | <pre>map(object({<br/>    value       = string<br/>    type        = optional(string, "String")<br/>    description = optional(string)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_parameter_arns"></a> [parameter\_arns](#output\_parameter\_arns) | n/a |
| <a name="output_parameter_name_prefix"></a> [parameter\_name\_prefix](#output\_parameter\_name\_prefix) | SSM parameter path prefix. |
| <a name="output_parameter_names"></a> [parameter\_names](#output\_parameter\_names) | n/a |
| <a name="output_secure_parameter_names"></a> [secure\_parameter\_names](#output\_secure\_parameter\_names) | n/a |
| <a name="output_string_parameter_names"></a> [string\_parameter\_names](#output\_string\_parameter\_names) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
