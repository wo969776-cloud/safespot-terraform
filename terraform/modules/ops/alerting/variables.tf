variable "project" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "alert_email" {
  description = "CloudWatch Alarm → SNS Email 구독 주소"
  type        = string

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.alert_email))
    error_message = "alert_email은 유효한 이메일 형식이어야 합니다."
  }
}

variable "additional_email_subscriptions" {
  description = "추가 Email 구독 주소 목록"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for email in var.additional_email_subscriptions :
      can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", email))
    ])
    error_message = "additional_email_subscriptions의 모든 값은 유효한 이메일 형식이어야 합니다."
  }
}

variable "slack_webhook_secret_name" {
  description = "Secrets Manager에 저장할 AlertManager Slack Webhook URL 시크릿 이름"
  type        = string
  default     = ""
}

variable "slack_webhook_recovery_window_days" {
  description = "Secrets Manager 시크릿 삭제 후 복구 가능 기간"
  type        = number
  default     = 7

  validation {
    condition     = var.slack_webhook_recovery_window_days >= 0 && var.slack_webhook_recovery_window_days <= 30
    error_message = "slack_webhook_recovery_window_days는 0 이상 30 이하여야 합니다."
  }
}

variable "enable_slack_secret" {
  description = "AlertManager Slack Webhook Secret 생성 여부"
  type        = bool
  default     = true
}

variable "allowed_aws_services" {
  description = "SNS Topic에 Publish 권한을 부여할 AWS 서비스 목록"
  type        = list(string)
  default     = ["cloudwatch.amazonaws.com"]
}

variable "slack_webhook_url" {
  description = "AlertManager Slack Webhook URL. 비어 있으면 Secret 값 없이 시크릿 이름만 생성."
  type        = string
  sensitive   = true
  default     = ""
}