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

# ── Aurora ──────────────────────────────────────────────

variable "availability_zones" {
  description = "Availability zones for Aurora Multi-AZ"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "rds_engine_version" {
  description = "Aurora PostgreSQL engine version"
  type        = string
  default     = "15.6"
}

variable "rds_instance_class" {
  description = "Aurora instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "rds_instance_count" {
  description = "Total Aurora instances (writer 1 + readers)"
  type        = number
  default     = 2
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Master username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "rds_backup_retention_period" {
  description = "Backup retention in days"
  type        = number
  default     = 7
}

variable "rds_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "rds_skip_final_snapshot" {
  description = "Skip final snapshot on destroy"
  type        = bool
  default     = true
}

# ── Redis ────────────────────────────────────────────────

variable "redis_engine_version" {
  description = "Redis engine version"
  type        = string
  default     = "7.1"
}

variable "redis_node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "redis_num_cache_clusters" {
  description = "Total Redis nodes (master 1 + replica 4 = 5)"
  type        = number
  default     = 5
}

variable "redis_snapshot_retention_limit" {
  description = "Redis snapshot retention in days"
  type        = number
  default     = 1
}