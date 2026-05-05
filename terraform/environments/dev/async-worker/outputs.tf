# ── api-service 연동 output ───────────────────────────────────────
# cache_refresh 큐를 대표 event queue로 매핑한다.

output "event_queue_name" {
  description = "Representative event queue name (cache_refresh)."
  value       = module.sqs.cache_refresh_queue_name
}

output "event_queue_arn" {
  description = "Representative event queue ARN (cache_refresh)."
  value       = module.sqs.cache_refresh_queue_arn
}

output "event_queue_url" {
  description = "Representative event queue URL (cache_refresh)."
  value       = module.sqs.cache_refresh_queue_url
}

output "event_dlq_name" {
  description = "Representative event DLQ name (cache_refresh DLQ)."
  value       = module.sqs.cache_refresh_dlq_name
}

output "event_dlq_arn" {
  description = "Representative event DLQ ARN (cache_refresh DLQ)."
  value       = module.sqs.cache_refresh_dlq_arn
}

output "event_dlq_url" {
  description = "Representative event DLQ URL (cache_refresh DLQ)."
  value       = module.sqs.cache_refresh_dlq_url
}

# ── Queue ARN (external-ingestion / api-service publish 권한용) ───

output "cache_refresh_queue_arn" {
  description = "Cache refresh queue ARN for IAM policy."
  value       = module.sqs.cache_refresh_queue_arn
}

output "readmodel_refresh_queue_arn" {
  description = "Readmodel refresh queue ARN for IAM policy."
  value       = module.sqs.readmodel_refresh_queue_arn
}

output "environment_cache_refresh_queue_arn" {
  description = "Environment cache refresh queue ARN for IAM policy."
  value       = module.sqs.environment_cache_refresh_queue_arn
}

# ── ops monitoring output — SQS ───────────────────────────────────

output "sqs_queue_name_cache_refresh" {
  description = "AWS QueueName: safespot-{env}-async-worker-sqs-cache-refresh"
  value       = module.sqs.cache_refresh_queue_name
}

output "sqs_queue_name_readmodel" {
  description = "AWS QueueName: safespot-{env}-async-worker-sqs-readmodel-refresh"
  value       = module.sqs.readmodel_refresh_queue_name
}

output "sqs_queue_name_env_cache" {
  description = "AWS QueueName: safespot-{env}-async-worker-sqs-environment-cache-refresh"
  value       = module.sqs.environment_cache_refresh_queue_name
}

output "sqs_dlq_name" {
  description = "Primary DLQ name (cache_refresh DLQ)."
  value       = module.sqs.cache_refresh_dlq_name
}

output "sqs_dlq_name_cache_refresh" {
  description = "AWS QueueName: safespot-{env}-async-worker-dlq-cache-refresh"
  value       = module.sqs.cache_refresh_dlq_name
}

output "sqs_dlq_name_readmodel_refresh" {
  description = "AWS QueueName: safespot-{env}-async-worker-dlq-readmodel-refresh"
  value       = module.sqs.readmodel_refresh_dlq_name
}

output "sqs_dlq_name_environment_cache_refresh" {
  description = "AWS QueueName: safespot-{env}-async-worker-dlq-environment-cache-refresh"
  value       = module.sqs.environment_cache_refresh_dlq_name
}

# ── ops monitoring output — Lambda (실제 리소스 기반) ─────────────

output "lambda_function_name" {
  description = "Async-worker Lambda function name for ops CloudWatch FunctionName dimension."
  value       = module.lambda.lambda_function_name
}

output "lambda_function_arn" {
  description = "Async-worker Lambda function ARN."
  value       = module.lambda.lambda_function_arn
}

output "lambda_reserved_concurrent_executions" {
  description = "Async-worker Lambda reserved concurrency for ops alert threshold."
  value       = module.lambda.lambda_reserved_concurrent_executions
}
