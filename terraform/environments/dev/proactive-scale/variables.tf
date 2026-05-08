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

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "max_receive_count" {
  description = "Number of receives before DLQ. PoisonMessage는 3회 후 DLQ로 이동"
  type        = number
  default     = 3
}

variable "visibility_timeout_seconds" {
  description = "SQS visibility timeout. HPA GET+PATCH 처리 시간 대비 여유"
  type        = number
  default     = 60
}

variable "message_retention_seconds" {
  description = "SQS message retention in seconds"
  type        = number
  default     = 345600
}

variable "dlq_message_retention_seconds" {
  description = "DLQ message retention in seconds"
  type        = number
  default     = 1209600
}
