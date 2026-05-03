variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "queue_name" {
  description = "Logical queue name suffix"
  type        = string
  default     = "event"
}

# visibility_timeout은 consumer 처리 시간보다 커야 한다
# 실제 Lambda timeout 기준으로 조정 필요
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

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}
