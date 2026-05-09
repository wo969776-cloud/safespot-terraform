# ── 하위 호환 output (api-service 연동, 변경 금지) ───────────────
# cache_refresh 큐를 대표 event queue로 매핑. 기존 계약 유지.

output "event_queue_name" {
  description = "Representative event queue name (cache_refresh). Kept for backward compatibility."
  value       = module.sqs.cache_refresh_queue_name
}

output "event_queue_arn" {
  description = "Representative event queue ARN (cache_refresh). Kept for backward compatibility."
  value       = module.sqs.cache_refresh_queue_arn
}

output "event_queue_url" {
  description = "Representative event queue URL (cache_refresh). Kept for backward compatibility."
  value       = module.sqs.cache_refresh_queue_url
}

output "event_dlq_name" {
  description = "Representative event DLQ name (cache_refresh DLQ). Kept for backward compatibility."
  value       = module.sqs.cache_refresh_dlq_name
}

output "event_dlq_arn" {
  description = "Representative event DLQ ARN (cache_refresh DLQ). Kept for backward compatibility."
  value       = module.sqs.cache_refresh_dlq_arn
}

output "event_dlq_url" {
  description = "Representative event DLQ URL (cache_refresh DLQ). Kept for backward compatibility."
  value       = module.sqs.cache_refresh_dlq_url
}

# ── Cache Refresh Queue ───────────────────────────────────────────

output "cache_refresh_queue_name" {
  description = "Cache refresh queue name."
  value       = module.sqs.cache_refresh_queue_name
}

output "cache_refresh_queue_arn" {
  description = "Cache refresh queue ARN."
  value       = module.sqs.cache_refresh_queue_arn
}

output "cache_refresh_queue_url" {
  description = "Cache refresh queue URL."
  value       = module.sqs.cache_refresh_queue_url
}

output "cache_refresh_dlq_name" {
  description = "Cache refresh DLQ name."
  value       = module.sqs.cache_refresh_dlq_name
}

output "cache_refresh_dlq_arn" {
  description = "Cache refresh DLQ ARN."
  value       = module.sqs.cache_refresh_dlq_arn
}

output "cache_refresh_dlq_url" {
  description = "Cache refresh DLQ URL."
  value       = module.sqs.cache_refresh_dlq_url
}

# ── Readmodel Refresh Queue ───────────────────────────────────────

output "readmodel_refresh_queue_name" {
  description = "Readmodel refresh queue name."
  value       = module.sqs.readmodel_refresh_queue_name
}

output "readmodel_refresh_queue_arn" {
  description = "Readmodel refresh queue ARN."
  value       = module.sqs.readmodel_refresh_queue_arn
}

output "readmodel_refresh_queue_url" {
  description = "Readmodel refresh queue URL."
  value       = module.sqs.readmodel_refresh_queue_url
}

output "readmodel_refresh_dlq_name" {
  description = "Readmodel refresh DLQ name."
  value       = module.sqs.readmodel_refresh_dlq_name
}

output "readmodel_refresh_dlq_arn" {
  description = "Readmodel refresh DLQ ARN."
  value       = module.sqs.readmodel_refresh_dlq_arn
}

output "readmodel_refresh_dlq_url" {
  description = "Readmodel refresh DLQ URL."
  value       = module.sqs.readmodel_refresh_dlq_url
}

# ── Environment Cache Refresh Queue ──────────────────────────────

output "environment_cache_refresh_queue_name" {
  description = "Environment cache refresh queue name."
  value       = module.sqs.environment_cache_refresh_queue_name
}

output "environment_cache_refresh_queue_arn" {
  description = "Environment cache refresh queue ARN."
  value       = module.sqs.environment_cache_refresh_queue_arn
}

output "environment_cache_refresh_queue_url" {
  description = "Environment cache refresh queue URL."
  value       = module.sqs.environment_cache_refresh_queue_url
}

output "environment_cache_refresh_dlq_name" {
  description = "Environment cache refresh DLQ name."
  value       = module.sqs.environment_cache_refresh_dlq_name
}

output "environment_cache_refresh_dlq_arn" {
  description = "Environment cache refresh DLQ ARN."
  value       = module.sqs.environment_cache_refresh_dlq_arn
}

output "environment_cache_refresh_dlq_url" {
  description = "Environment cache refresh DLQ URL."
  value       = module.sqs.environment_cache_refresh_dlq_url
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
  description = "Primary DLQ name for backward compat (cache_refresh DLQ)."
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

# ── multi-queue 구조 map output ──────────────────────────────────
# remote state에서 단일 참조로 3개 queue 정보를 모두 접근 가능

output "queue_names" {
  description = "All async-worker queue names keyed by logical name."
  value = {
    cache_refresh       = module.sqs.cache_refresh_queue_name
    readmodel_refresh   = module.sqs.readmodel_refresh_queue_name
    environment_refresh = module.sqs.environment_cache_refresh_queue_name
  }
}

output "queue_arns" {
  description = "All async-worker queue ARNs keyed by logical name."
  value = {
    cache_refresh       = module.sqs.cache_refresh_queue_arn
    readmodel_refresh   = module.sqs.readmodel_refresh_queue_arn
    environment_refresh = module.sqs.environment_cache_refresh_queue_arn
  }
}

output "queue_urls" {
  description = "All async-worker queue URLs keyed by logical name."
  value = {
    cache_refresh       = module.sqs.cache_refresh_queue_url
    readmodel_refresh   = module.sqs.readmodel_refresh_queue_url
    environment_refresh = module.sqs.environment_cache_refresh_queue_url
  }
}

output "dlq_names" {
  description = "All async-worker DLQ names keyed by logical name."
  value = {
    cache_refresh       = module.sqs.cache_refresh_dlq_name
    readmodel_refresh   = module.sqs.readmodel_refresh_dlq_name
    environment_refresh = module.sqs.environment_cache_refresh_dlq_name
  }
}

output "dlq_arns" {
  description = "All async-worker DLQ ARNs keyed by logical name."
  value = {
    cache_refresh       = module.sqs.cache_refresh_dlq_arn
    readmodel_refresh   = module.sqs.readmodel_refresh_dlq_arn
    environment_refresh = module.sqs.environment_cache_refresh_dlq_arn
  }
}

output "dlq_urls" {
  description = "All async-worker DLQ URLs keyed by logical name."
  value = {
    cache_refresh       = module.sqs.cache_refresh_dlq_url
    readmodel_refresh   = module.sqs.readmodel_refresh_dlq_url
    environment_refresh = module.sqs.environment_cache_refresh_dlq_url
  }
}

# ── ops monitoring output — Lambda ────────────────────────────────

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
