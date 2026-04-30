variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "redis_sg_id" {
  description = "Redis Security Group ID"
  type        = string
}

variable "engine_version" {
  description = "Redis engine version"
  type        = string
  default     = "7.1"
}

variable "node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "num_cache_clusters" {
  description = "Total Redis nodes (master 1 + replica 4 = 5)"
  type        = number
  default     = 5
}

variable "snapshot_retention_limit" {
  description = "Snapshot retention in days"
  type        = number
  default     = 1
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}
variable "redis_port" {
  description = "Redis port"
  type        = number
  default     = 6379
}
