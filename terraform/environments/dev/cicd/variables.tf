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

variable "aws_region" {
  type = string
}

variable "github_org" {
  type    = string
  default = "project-safespot"
}

variable "github_repos" {
  description = "OIDC role을 생성할 repo 목록 (short name, org 제외)"
  type        = list(string)
  default     = []
}

variable "ecr_push_repos" {
  description = "ECR push 권한을 받을 repo 목록 (short name, org 제외)"
  type        = list(string)
  default     = []
}

variable "terraform_repos" {
  description = "Terraform state 접근 권한을 받을 repo 목록 (short name, org 제외)"
  type        = list(string)
  default     = []
}

variable "frontend_deploy_repos" {
  description = "Frontend S3/CloudFront 권한을 받을 repo 목록 (short name, org 제외)"
  type        = list(string)
  default     = []
}

variable "allowed_branches" {
  type    = list(string)
  default = ["main"]
}

variable "allow_pull_request_oidc" {
  type    = bool
  default = false
}

variable "terraform_state_bucket" {
  type = string
}

variable "terraform_state_key_prefixes" {
  description = "비워두면 locals.tf의 환경별 기본 prefix 목록을 사용"
  type        = list(string)
  default     = []
}

variable "ecr_repository_arns" {
  description = "비워두면 ops remote state에서 자동으로 읽음. 서비스명 → ARN map."
  type        = map(string)
  default     = {}
}

variable "enable_terraform_apply" {
  type    = bool
  default = false
}


variable "common_tags" {
  type    = map(string)
  default = {}
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
  description = "SSM SecureString KMS key ARN. 비워두면 CICD apply role에 KMS 권한을 부여하지 않습니다."
  type        = string
  default     = ""

  validation {
    condition     = var.ssm_kms_key_arn != "*"
    error_message = "ssm_kms_key_arn에는 wildcard(*)를 사용할 수 없습니다. 비워두거나 특정 KMS key ARN을 지정하세요."
  }
}
