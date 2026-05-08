output "sns_topic_arn" {
  value = aws_sns_topic.ops_alert.arn
}

output "sns_topic_name" {
  value = aws_sns_topic.ops_alert.name
}

output "edge_sns_topic_arn" {
  description = "CloudFront/WAF global metric alarm action SNS Topic ARN. us-east-1에 생성됩니다."
  value       = aws_sns_topic.ops_alert_edge.arn
}

output "edge_sns_topic_name" {
  value = aws_sns_topic.ops_alert_edge.name
}

output "slack_webhook_secret_arn" {
  description = "SSM Parameter ARN (콘솔에서 직접 값 입력 필요)"
  value       = var.enable_slack_secret ? aws_ssm_parameter.slack_webhook[0].arn : null
}

output "slack_webhook_secret_name" {
  description = "SSM Parameter 이름 (콘솔에서 직접 값 입력 필요)"
  value       = var.enable_slack_secret ? aws_ssm_parameter.slack_webhook[0].name : null
}

output "alertmanager_secret_read_policy_arn" {
  value = var.enable_slack_secret ? aws_iam_policy.alertmanager_secret_read[0].arn : null
}
