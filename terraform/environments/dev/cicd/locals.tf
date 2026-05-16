locals {
  remote_state_bucket = var.terraform_state_bucket
  remote_state_region = var.aws_region

  terraform_state_key_prefixes = length(var.terraform_state_key_prefixes) > 0 ? var.terraform_state_key_prefixes : [
    "environments/${var.environment}/network/",
    "environments/${var.environment}/data/",
    "environments/${var.environment}/api-service/",
    "environments/${var.environment}/edge/",
    "environments/${var.environment}/async-worker/",
    "environments/${var.environment}/ops/",
    "environments/${var.environment}/ops/cicd/",
  ]
}
