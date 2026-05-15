variable "project" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID. ALB/VPC Flow 버킷 정책의 SourceAccount 조건에 사용."
  type        = string
}

variable "force_destroy" {
  description = "버킷 삭제 시 오브젝트를 자동 제거할지 여부. prod에서는 false 권장."
  type        = bool
  default     = false
}

# ── 라이프사이클 ──────────────────────────────────────────────

variable "alb_retention_days" {
  description = "ALB 접근 로그 보존 기간 (일)."
  type        = number
  default     = 90
}

variable "waf_retention_days" {
  description = "WAF 로그 보존 기간 (일)."
  type        = number
  default     = 90
}

variable "vpc_flow_retention_days" {
  description = "VPC Flow 로그 보존 기간 (일)."
  type        = number
  default     = 90
}

variable "rds_retention_days" {
  description = "RDS 로그 보존 기간 (일)."
  type        = number
  default     = 90
}

variable "cloudwatch_retention_days" {
  description = "CloudWatch 내보내기 로그 보존 기간 (일)."
  type        = number
  default     = 365
}

variable "cloudfront_retention_days" {
  description = "CloudFront 접근 로그 보존 기간 (일)."
  type        = number
  default     = 30
}

# ── 옵션 기능 ─────────────────────────────────────────────────

variable "enable_versioning" {
  description = "S3 버전 관리 활성화 여부."
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "서버 측 암호화에 사용할 KMS 키 ARN. 비어 있으면 AES-256(SSE-S3)을 사용."
  type        = string
  default     = ""
}

variable "tags" {
  description = "추가 태그 맵."
  type        = map(string)
  default     = {}
}
