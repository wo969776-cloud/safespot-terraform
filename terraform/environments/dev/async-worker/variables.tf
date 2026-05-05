variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

# visibility_timeout은 lambda_timeout보다 커야 한다
variable "visibility_timeout_seconds" {
  description = "SQS visibility timeout in seconds"
  type        = number
  default     = 180
}

# consumer 장애 시 이벤트 유실 방지를 위해 retention 확장
variable "message_retention_seconds" {
  description = "SQS message retention period in seconds"
  type        = number
  default     = 345600
}

variable "dlq_message_retention_seconds" {
  description = "DLQ message retention period in seconds"
  type        = number
  default     = 1209600
}

variable "max_receive_count" {
  description = "Number of receives before moving to DLQ"
  type        = number
  default     = 5
}

variable "lambda_filename" {
  description = "Relative path to Lambda deployment ZIP (from terraform/environments/dev/async-worker/)"
  type        = string
}

# DB 인증 정보는 절대 tfvars에 작성하지 않는다
# terraform apply -var="db_user=xxx" -var="db_password=yyy"
variable "db_user" {
  description = "Aurora DB username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Aurora DB password"
  type        = string
  sensitive   = true
}

variable "lambda_handler" {
  description = "Lambda handler class (fully qualified class::method)"
  type        = string
}
