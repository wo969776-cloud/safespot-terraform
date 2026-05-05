# ── Cache Refresh DLQ ────────────────────────────────────────────
resource "aws_sqs_queue" "cache_refresh_dlq" {
  name                      = "${var.project}-${var.environment}-async-worker-dlq-cache-refresh"
  message_retention_seconds = var.dlq_message_retention_seconds

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-async-worker-dlq-cache-refresh"
  })
}

# ── Readmodel Refresh DLQ ─────────────────────────────────────────
resource "aws_sqs_queue" "readmodel_refresh_dlq" {
  name                      = "${var.project}-${var.environment}-async-worker-dlq-readmodel-refresh"
  message_retention_seconds = var.dlq_message_retention_seconds

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-async-worker-dlq-readmodel-refresh"
  })
}

# ── Environment Cache Refresh DLQ ────────────────────────────────
resource "aws_sqs_queue" "environment_cache_refresh_dlq" {
  name                      = "${var.project}-${var.environment}-async-worker-dlq-environment-cache-refresh"
  message_retention_seconds = var.dlq_message_retention_seconds

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-async-worker-dlq-environment-cache-refresh"
  })
}

# ── Cache Refresh Queue ───────────────────────────────────────────
# Trigger: EvacuationEntryCreated, EvacuationEntryExited, EvacuationEntryUpdated, ShelterUpdated, CacheRegenerationRequested
resource "aws_sqs_queue" "cache_refresh" {
  name                       = "${var.project}-${var.environment}-async-worker-sqs-cache-refresh"
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.cache_refresh_dlq.arn
    # transient 장애(Redis, DB, network 등)로 인한 일시적 실패를 고려해
    # 일정 횟수 재시도 후 전용 DLQ로 이동
    # consumer 처리 특성 및 장애 패턴에 따라 값 조정 필요
    maxReceiveCount = var.max_receive_count
  })

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-async-worker-sqs-cache-refresh"
  })
}

# ── Readmodel Refresh Queue ───────────────────────────────────────
# Trigger: DisasterDataCollected, CacheRegenerationRequested (disaster message keys)
resource "aws_sqs_queue" "readmodel_refresh" {
  name                       = "${var.project}-${var.environment}-async-worker-sqs-readmodel-refresh"
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.readmodel_refresh_dlq.arn
    maxReceiveCount     = var.max_receive_count
  })

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-async-worker-sqs-readmodel-refresh"
  })
}

# ── Environment Cache Refresh Queue ──────────────────────────────
# Trigger: EnvironmentDataCollected, CacheRegenerationRequested (environment keys)
resource "aws_sqs_queue" "environment_cache_refresh" {
  name                       = "${var.project}-${var.environment}-async-worker-sqs-environment-cache-refresh"
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.environment_cache_refresh_dlq.arn
    maxReceiveCount     = var.max_receive_count
  })

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-async-worker-sqs-environment-cache-refresh"
  })
}
