output "aurora_cluster_endpoint" {
  description = "Aurora writer endpoint"
  value       = module.rds.cluster_endpoint
}

output "aurora_reader_endpoint" {
  description = "Aurora reader endpoint"
  value       = module.rds.cluster_reader_endpoint
}

output "aurora_port" {
  description = "Aurora port"
  value       = module.rds.cluster_port
}

output "aurora_db_name" {
  description = "Database name"
  value       = module.rds.db_name
}

output "redis_primary_endpoint" {
  description = "Redis primary (writer) endpoint"
  value       = module.redis.redis_primary_endpoint
}

output "redis_reader_endpoint" {
  description = "Redis reader endpoint (레플리카 로드밸런싱)"
  value       = module.redis.redis_reader_endpoint
}

output "redis_port" {
  description = "Redis port"
  value       = module.redis.redis_port
}

output "aurora_cluster_identifier" {
  description = "Aurora cluster identifier"
  value       = module.rds.cluster_identifier
}

output "redis_replication_group_id" {
  description = "Redis replication group ID"
  value       = module.redis.redis_cluster_id
}