resource "aws_cloudwatch_metric_alarm" "sqs_visible" {
  for_each = local.sqs_main_queues

  alarm_name          = "${local.name_prefix}-sqs-${each.key}-visible"
  alarm_description   = "SQS ${each.key} 대기 메시지 수 임계값 초과"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = local.default_evaluation_periods
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = local.default_period
  statistic           = "Maximum"
  threshold           = var.sqs_visible_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    QueueName = each.value
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.ok_actions
}

resource "aws_cloudwatch_metric_alarm" "sqs_oldest_age" {
  for_each = local.sqs_main_queues

  alarm_name          = "${local.name_prefix}-sqs-${each.key}-oldest-age"
  alarm_description   = "SQS ${each.key} 가장 오래된 메시지 대기 시간 임계값 초과"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = local.default_evaluation_periods
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = local.default_period
  statistic           = "Maximum"
  threshold           = var.sqs_age_threshold_seconds
  treat_missing_data  = "notBreaching"

  dimensions = {
    QueueName = each.value
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.ok_actions
}

resource "aws_cloudwatch_metric_alarm" "dlq_visible" {
  alarm_name          = "${local.name_prefix}-dlq-visible"
  alarm_description   = "DLQ 메시지 발생"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = local.default_period
  statistic           = "Maximum"
  threshold           = 0
  treat_missing_data  = "notBreaching"

  dimensions = {
    QueueName = var.sqs_queue_names.dlq
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.ok_actions
}

resource "aws_cloudwatch_metric_alarm" "sqs_in_flight" {
  for_each = local.sqs_main_queues

  alarm_name          = "${local.name_prefix}-sqs-${each.key}-in-flight"
  alarm_description   = "SQS ${each.key} in-flight(처리 중) 메시지 수 급증"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = local.default_evaluation_periods
  metric_name         = "ApproximateNumberOfMessagesNotVisible"
  namespace           = "AWS/SQS"
  period              = local.default_period
  statistic           = "Maximum"
  threshold           = var.sqs_in_flight_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    QueueName = each.value
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.ok_actions
}

resource "aws_cloudwatch_metric_alarm" "dlq_oldest_age" {
  alarm_name          = "${local.name_prefix}-dlq-oldest-age"
  alarm_description   = "DLQ 메시지 방치 시간 임계값 초과"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = local.default_period
  statistic           = "Maximum"
  threshold           = var.dlq_age_threshold_seconds
  treat_missing_data  = "notBreaching"

  dimensions = {
    QueueName = var.sqs_queue_names.dlq
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.ok_actions
}
