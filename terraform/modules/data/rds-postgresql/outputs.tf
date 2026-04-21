output "cluster_endpoint" {
  description = "Aurora writer endpoint (Active)"
  value       = aws_rds_cluster.main.endpoint
}

output "cluster_reader_endpoint" {
  description = "Aurora reader endpoint (Standby)"
  value       = aws_rds_cluster.main.reader_endpoint
}

output "cluster_port" {
  description = "Aurora port"
  value       = aws_rds_cluster.main.port
}

output "db_name" {
  description = "Database name"
  value       = aws_rds_cluster.main.database_name
}

output "cluster_identifier" {
  description = "Aurora cluster identifier"
  value       = aws_rds_cluster.main.cluster_identifier
}