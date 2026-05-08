output "redis_primary_endpoint" {
  description = "Redis primary (master) endpoint"
  value       = aws_elasticache_replication_group.main.primary_endpoint_address
}

output "redis_reader_endpoint" {
  description = "Redis reader endpoint (replica 로드밸런싱)"
  value       = aws_elasticache_replication_group.main.reader_endpoint_address
}

output "redis_port" {
  description = "Redis port"
  value       = aws_elasticache_replication_group.main.port
}

output "redis_cluster_id" {
  description = "Redis replication group ID"
  value       = aws_elasticache_replication_group.main.id
}