locals {
  domain      = "ops"
  name_prefix = "${var.project}-${var.environment}-${local.domain}"

  sns_topic_name      = "${local.name_prefix}-sns-alert"
  edge_sns_topic_name = "${local.name_prefix}-sns-alert-edge"

  slack_secret_name = (
    var.slack_webhook_secret_name != ""
    ? var.slack_webhook_secret_name
    : "${var.project}/${var.environment}/alertmanager/slack-webhook"
  )

  all_email_subscriptions = concat(
    [var.alert_email],
    var.additional_email_subscriptions
  )
}
