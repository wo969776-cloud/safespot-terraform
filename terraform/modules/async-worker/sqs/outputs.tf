# ── Cache Refresh Queue ───────────────────────────────────────────

output "cache_refresh_queue_name" {
  description = "Cache refresh queue name."
  value       = aws_sqs_queue.cache_refresh.name
}

output "cache_refresh_queue_arn" {
  description = "Cache refresh queue ARN."
  value       = aws_sqs_queue.cache_refresh.arn
}

output "cache_refresh_queue_url" {
  description = "Cache refresh queue URL."
  value       = aws_sqs_queue.cache_refresh.url
}

output "cache_refresh_dlq_name" {
  description = "Cache refresh dead-letter queue name."
  value       = aws_sqs_queue.cache_refresh_dlq.name
}

output "cache_refresh_dlq_arn" {
  description = "Cache refresh dead-letter queue ARN."
  value       = aws_sqs_queue.cache_refresh_dlq.arn
}

output "cache_refresh_dlq_url" {
  description = "Cache refresh dead-letter queue URL."
  value       = aws_sqs_queue.cache_refresh_dlq.url
}

# ── Readmodel Refresh Queue ───────────────────────────────────────

output "readmodel_refresh_queue_name" {
  description = "Readmodel refresh queue name."
  value       = aws_sqs_queue.readmodel_refresh.name
}

output "readmodel_refresh_queue_arn" {
  description = "Readmodel refresh queue ARN."
  value       = aws_sqs_queue.readmodel_refresh.arn
}

output "readmodel_refresh_queue_url" {
  description = "Readmodel refresh queue URL."
  value       = aws_sqs_queue.readmodel_refresh.url
}

output "readmodel_refresh_dlq_name" {
  description = "Readmodel refresh dead-letter queue name."
  value       = aws_sqs_queue.readmodel_refresh_dlq.name
}

output "readmodel_refresh_dlq_arn" {
  description = "Readmodel refresh dead-letter queue ARN."
  value       = aws_sqs_queue.readmodel_refresh_dlq.arn
}

output "readmodel_refresh_dlq_url" {
  description = "Readmodel refresh dead-letter queue URL."
  value       = aws_sqs_queue.readmodel_refresh_dlq.url
}

# ── Environment Cache Refresh Queue ──────────────────────────────

output "environment_cache_refresh_queue_name" {
  description = "Environment cache refresh queue name."
  value       = aws_sqs_queue.environment_cache_refresh.name
}

output "environment_cache_refresh_queue_arn" {
  description = "Environment cache refresh queue ARN."
  value       = aws_sqs_queue.environment_cache_refresh.arn
}

output "environment_cache_refresh_queue_url" {
  description = "Environment cache refresh queue URL."
  value       = aws_sqs_queue.environment_cache_refresh.url
}

output "environment_cache_refresh_dlq_name" {
  description = "Environment cache refresh dead-letter queue name."
  value       = aws_sqs_queue.environment_cache_refresh_dlq.name
}

output "environment_cache_refresh_dlq_arn" {
  description = "Environment cache refresh dead-letter queue ARN."
  value       = aws_sqs_queue.environment_cache_refresh_dlq.arn
}

output "environment_cache_refresh_dlq_url" {
  description = "Environment cache refresh dead-letter queue URL."
  value       = aws_sqs_queue.environment_cache_refresh_dlq.url
}
