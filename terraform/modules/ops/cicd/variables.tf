variable "project" {
  type    = string
  default = "safespot"
}

variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "stg", "prod"], var.environment)
    error_message = "env는 dev, stg, prod 중 하나여야 합니다."
  }
}

variable "github_org" {
  type    = string
  default = "project-safespot"
}

variable "github_repos" {
  type = list(string)

  default = [
    "safespot-applicaton",
    "safespot-front"
  ]
}

variable "allowed_branches" {
  type = list(string)

  default = ["main"]
}

variable "allowed_github_environments" {
  description = "OIDC trust policy??허용할 GitHub Environment 이름 목록"
  type        = list(string)
  default     = []
}

variable "allow_pull_request_oidc" {
  type    = bool
  default = false
}

variable "terraform_state_bucket" {
  type = string
}

variable "terraform_state_key_prefixes" {
  type = list(string)
}

variable "ecr_repository_arns" {
  description = "ECR repository ARN map. 서비스명 → ARN 형태. ops remote state ecr_repository_arns output과 동일한 구조."
  type        = map(string)
}

variable "enable_terraform_apply" {
  type    = bool
  default = false
}


variable "aws_region" {
  type = string
}

variable "account_id" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "frontend_s3_bucket" {
  type    = string
  default = ""
}

variable "cloudfront_distribution_id" {
  type    = string
  default = ""
}

variable "ssm_kms_key_arn" {
  description = "KMS key ARN for SSM SecureString. 비워두면 KMS 권한 statement를 생성하지 않습니다."
  type        = string
  default     = ""

  validation {
    condition     = var.ssm_kms_key_arn != "*"
    error_message = "ssm_kms_key_arn에는 wildcard(*)를 사용할 수 없습니다. 비워두거나 특정 KMS key ARN을 지정하세요."
  }
}

variable "ecr_push_repos" {
  description = "ECR push 권한을 부여할 repo 목록 (short name, org 제외)"
  type        = list(string)
  default     = []
}

variable "terraform_repos" {
  description = "Terraform state 접근 권한을 부여할 repo 목록 (short name, org 제외)"
  type        = list(string)
  default     = []
}

variable "frontend_deploy_repos" {
  description = "Frontend S3/CloudFront 권한을 부여할 repo 목록 (short name, org 제외)"
  type        = list(string)
  default     = []
}

variable "lambda_deploy_repos" {
  description = "Lambda code deploy 권한을 부여할 repo 목록 (short name, org 제외)"
  type        = list(string)
  default     = []
}
