variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "lambda_filename" {
  description = "Absolute path to Lambda deployment ZIP file"
  type        = string
}

variable "lambda_handler" {
  description = "Lambda handler class (fully qualified class::method)"
  type        = string
}

# visibility_timeout_seconds보다 작아야 한다 (SQS가 처리 중 메시지를 재노출하지 않도록)
variable "lambda_timeout" {
  description = "Lambda function timeout in seconds. Must be less than SQS visibility_timeout_seconds."
  type        = number
  default     = 120
}

variable "lambda_memory_size" {
  description = "Lambda memory size in MB (Java 21 minimum 512 권장)"
  type        = number
  default     = 512
}

variable "reserved_concurrent_executions" {
  description = "Reserved concurrency for async-worker Lambda"
  type        = number
  default     = 10
}

variable "batch_size" {
  description = "SQS event source mapping batch size"
  type        = number
  default     = 10
}

variable "maximum_batching_window_in_seconds" {
  description = "SQS event source mapping batching window"
  type        = number
  default     = 5
}

variable "cache_refresh_queue_arn" {
  description = "Cache refresh SQS queue ARN"
  type        = string
}

variable "readmodel_refresh_queue_arn" {
  description = "Readmodel refresh SQS queue ARN"
  type        = string
}

variable "environment_cache_refresh_queue_arn" {
  description = "Environment cache refresh SQS queue ARN"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for Lambda VPC config"
  type        = list(string)
}

variable "lambda_sg_id" {
  description = "Lambda security group ID"
  type        = string
}

variable "db_host" {
  description = "Aurora cluster endpoint (writer)"
  type        = string
}

variable "db_port" {
  description = "Aurora port"
  type        = number
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database user"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "redis_host" {
  description = "Redis primary endpoint"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}
