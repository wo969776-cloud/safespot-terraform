locals {
  domain      = "ops"
  name_prefix = "${var.project}-${var.environment}-${local.domain}"

  alarm_actions       = [var.sns_topic_arn]
  critical_ok_actions = [var.sns_topic_arn]
  ok_actions          = [var.sns_topic_arn]
  edge_alarm_actions  = [var.edge_sns_topic_arn]
  edge_ok_actions     = [var.edge_sns_topic_arn]

  default_evaluation_periods = 3
  default_period             = 60

  sqs_main_queues = {
    cache_refresh = var.sqs_queue_names.cache_refresh
    readmodel     = var.sqs_queue_names.readmodel
    env_cache     = var.sqs_queue_names.env_cache
  }
}
