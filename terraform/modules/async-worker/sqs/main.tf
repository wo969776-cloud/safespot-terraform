# Dead Letter Queue
resource "aws_sqs_queue" "event_dlq" {
  name                      = "${var.project}-${var.environment}-async-worker-sqs-${var.queue_name}-dlq"
  message_retention_seconds = var.dlq_message_retention_seconds

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-async-worker-sqs-${var.queue_name}-dlq"
  })
}

# Main Event Queue
resource "aws_sqs_queue" "event" {
  name                       = "${var.project}-${var.environment}-async-worker-sqs-${var.queue_name}"
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.event_dlq.arn

    # transient 장애(Redis, DB, network 등)로 인한 일시적 실패를 고려해
    # 일정 횟수 재시도 후 DLQ로 이동
    # consumer 처리 특성 및 장애 패턴에 따라 값 조정 필요
    maxReceiveCount = var.max_receive_count
  })

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-async-worker-sqs-${var.queue_name}"
  })
}
