variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
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

# Lambda ESM이 폴링하므로 long polling(20s)으로 빈 응답을 줄인다
variable "receive_wait_time_seconds" {
  description = "SQS long polling wait time in seconds"
  type        = number
  default     = 20
}

variable "delay_seconds" {
  description = "SQS message delivery delay in seconds"
  type        = number
  default     = 0
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}
