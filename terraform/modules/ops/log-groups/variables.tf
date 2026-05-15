variable "project" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "배포 환경 (dev / stg / prod)"
  type        = string
}

variable "retention_days" {
  description = "CloudWatch Log Group 기본 보존 기간 (일). 유효값: 1,3,5,7,14,30,60,90,..."
  type        = number
  default     = 30

  validation {
    condition = contains(
      [0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400,
      545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653],
      var.retention_days
    )
    error_message = "retention_days는 CloudWatch 허용 값 중 하나여야 합니다."
  }
}

variable "lambda_retention_days" {
  description = "Lambda Log Group 보존 기간 (일)"
  type        = number
  default     = 60

  validation {
    condition = contains(
      [0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400,
      545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653],
      var.lambda_retention_days
    )
    error_message = "lambda_retention_days는 CloudWatch 허용 값 중 하나여야 합니다."
  }
}

variable "eks_control_plane_retention_days" {
  description = "EKS control plane Log Group 보존 기간 (일)"
  type        = number
  default     = 90

  validation {
    condition = contains(
      [0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400,
      545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653],
      var.eks_control_plane_retention_days
    )
    error_message = "eks_control_plane_retention_days는 CloudWatch 허용 값 중 하나여야 합니다."
  }
}

variable "eks_cluster_name" {
  description = "EKS 클러스터 이름. EKS control plane log group 이름 생성에 사용"
  type        = string
}

variable "eks_log_types" {
  description = "EKS control plane 로그 활성화 유형"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "lambda_function_name" {
  description = "async-worker Lambda 함수 이름. Lambda Log Group 이름 생성에 사용"
  type        = string
}

# [삭제] alb_log_bucket_name 제거

variable "enable_alb_log_group" {
  description = "ALB access log용 CloudWatch Log Group 생성 여부 (기본: false = S3 방식)"
  type        = bool
  default     = false
}

variable "services" {
  description = "Application Log Group을 생성할 서비스 이름 목록"
  type        = list(string)
  default = [
    "api-core",
    "api-public-read",
    "external-ingestion",
    "async-worker",
  ]
}

variable "kms_key_arn" {
  description = "Log Group 암호화에 사용할 KMS Key ARN. 비워두면 AWS 관리형 키 사용"
  type        = string
  default     = ""
}
