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
  description = "Path to async-worker Lambda deployment package (zip). Must be supplied at apply time via -var flag."
  type        = string
}

variable "lambda_handler" {
  description = "Lambda handler class (fully qualified class::method)"
  type        = string
}

variable "metrics_namespace" {
  description = "CloudWatch metrics namespace. Empty string disables CloudWatch metrics."
  type        = string
  default     = ""
}
