# terraform.tfvars
project     = "safespot"
environment = "dev"
aws_region  = "ap-northeast-2"

github_org = "project-safespot"

# short name만 기입 (org prefix 제외). 모듈이 github_org를 자동으로 붙임.
github_repos = [
  "safespot-terraform",
  "safespot-application",
  "safespot-front",
  "safespot-ops",
  "safespot-application-k8s-manifest",
]

# ECR push 권한을 받을 repo (application/container build repo만)
ecr_push_repos = [
  "safespot-application",
]

# Terraform state 읽기/쓰기 권한을 받을 repo
terraform_repos = [
  "safespot-terraform",
]

# Frontend S3 sync + CloudFront invalidation 권한을 받을 repo
frontend_deploy_repos = [
  "safespot-front",
]

lambda_deploy_repos = [
  "safespot-application",
]

terraform_state_bucket = "safespot-terraform-state"

frontend_s3_bucket         = "safespot-dev-frontend"
cloudfront_distribution_id = "E2PBOVHQ83HLN1"
