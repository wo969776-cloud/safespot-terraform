aws_region             = "ap-northeast-2"
project                = "safespot"
environment            = "dev"
terraform_state_bucket = "safespot-terraform-state"

common_tags = {
  Project     = "SafeSpot"
  Environment = "dev"
  ManagedBy   = "Terraform"
  Area        = "ssm-parameters"
}
