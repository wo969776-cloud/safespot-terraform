aws_region = "ap-northeast-2"
project    = "safespot"
env        = "dev"

remote_state_bucket = "safespot-terraform-state"
data_state_key      = "environments/dev/data/terraform.tfstate"

ssm_parameters = {
  "common/aws-region" = {
    value       = "ap-northeast-2"
    type        = "String"
    description = "AWS region"
  }

  "common/spring-profile" = {
    value       = "dev"
    type        = "String"
    description = "Spring profile"
  }
}
