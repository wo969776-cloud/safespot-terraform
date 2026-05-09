output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}

output "ecr_repository_arns" {
  value = module.ecr.repository_arns
}

output "ops_sns_topic_arn" {
  value = module.alerting.sns_topic_arn
}

output "ops_edge_sns_topic_arn" {
  value = module.alerting.edge_sns_topic_arn
}

output "slack_webhook_secret_arn" {
  value = module.alerting.slack_webhook_secret_arn
}

output "alertmanager_secret_read_policy_arn" {
  value = module.alerting.alertmanager_secret_read_policy_arn
}

output "cloudwatch_alarm_arns" {
  value = module.cloudwatch.alarm_arns
}

output "log_group_names" {
  value = module.log_groups.app_log_group_names
}

output "log_group_arns" {
  value = module.log_groups.app_log_group_arns
}

output "lambda_log_group_arn" {
  value = module.log_groups.lambda_log_group_arn
}

output "eks_control_plane_log_group_name" {
  value = module.log_groups.eks_control_plane_log_group_name
}

output "irsa_role_arns" {
  value = var.enable_observability_iam ? module.observability_iam[0].irsa_role_arns : null
}

output "cloudwatch_read_policy_arn" {
  value = var.enable_observability_iam ? module.observability_iam[0].cloudwatch_read_policy_arn : null
}

output "grafana_cloudwatch_read_policy_arn" {
  value = var.enable_observability_iam ? module.observability_iam[0].grafana_cloudwatch_read_policy_arn : null
}

output "grafana_irsa_role_arn" {
  description = "IAM role ARN for Grafana CloudWatch datasource IRSA."
  value       = var.enable_observability_iam ? module.observability_iam[0].grafana_irsa_role_arn : null
}

output "grafana_irsa_role_name" {
  value = var.enable_observability_iam ? module.observability_iam[0].grafana_irsa_role_name : null
}

output "grafana_irsa_subject" {
  value = var.enable_observability_iam ? module.observability_iam[0].grafana_irsa_subject : null
}

output "fluentbit_irsa_role_arn" {
  description = "IAM role ARN for Fluent Bit IRSA."
  value       = var.enable_observability_iam ? module.observability_iam[0].fluentbit_irsa_role_arn : null
}

output "fluentbit_irsa_role_name" {
  value = var.enable_observability_iam ? module.observability_iam[0].fluentbit_irsa_role_name : null
}

output "fluentbit_irsa_subject" {
  value = var.enable_observability_iam ? module.observability_iam[0].fluentbit_irsa_subject : null
}

output "yace_cloudwatch_read_policy_arn" {
  value = var.enable_observability_iam ? module.observability_iam[0].yace_cloudwatch_read_policy_arn : null
}

output "yace_irsa_role_arn" {
  description = "IAM role ARN for YACE IRSA."
  value       = var.enable_observability_iam ? module.observability_iam[0].yace_irsa_role_arn : null
}

output "yace_irsa_role_name" {
  value = var.enable_observability_iam ? module.observability_iam[0].yace_irsa_role_name : null
}

output "yace_irsa_subject" {
  value = var.enable_observability_iam ? module.observability_iam[0].yace_irsa_subject : null
}

output "log_bucket_id" {
  description = "S3 로그 버킷 이름."
  value       = module.log_bucket.bucket_id
}

output "log_bucket_arn" {
  description = "S3 로그 버킷 ARN."
  value       = module.log_bucket.bucket_arn
}

output "log_bucket_prefixes" {
  description = "서비스별 S3 prefix 맵."
  value       = module.log_bucket.prefixes
}

output "alb_log_prefix" {
  description = "ALB 접근 로그 설정에 사용할 S3 prefix."
  value       = module.log_bucket.alb_log_prefix
}

output "vpc_flow_log_prefix" {
  description = "VPC Flow 로그 설정에 사용할 S3 prefix."
  value       = module.log_bucket.vpc_flow_log_prefix
}
