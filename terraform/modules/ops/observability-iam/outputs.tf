output "cloudwatch_read_policy_arn" {
  description = "Prometheus CloudWatch exporter 읽기 전용 IAM Policy ARN"
  value       = var.enable_prometheus_irsa ? aws_iam_policy.cloudwatch_read[0].arn : null
}

output "prometheus_irsa_role_arn" {
  description = "Prometheus CloudWatch exporter IRSA Role ARN. enable_prometheus_irsa = false 이면 null 반환"
  value       = var.enable_prometheus_irsa ? module.prometheus_irsa[0].role_arn : null
}

output "prometheus_irsa_role_name" {
  description = "Prometheus IRSA Role 이름. enable_prometheus_irsa = false 이면 null 반환"
  value       = var.enable_prometheus_irsa ? module.prometheus_irsa[0].role_name : null
}

output "grafana_irsa_role_arn" {
  description = "IAM role ARN for Grafana CloudWatch datasource IRSA."
  value       = var.enable_grafana_irsa ? module.grafana_irsa[0].role_arn : null
}

output "grafana_irsa_role_name" {
  description = "IAM role name for Grafana CloudWatch datasource IRSA."
  value       = var.enable_grafana_irsa ? module.grafana_irsa[0].role_name : null
}

output "grafana_cloudwatch_read_policy_arn" {
  description = "Grafana CloudWatch datasource IAM Policy ARN. enable_grafana_irsa = false 이면 null 반환"
  value       = var.enable_grafana_irsa ? aws_iam_policy.grafana_cloudwatch_read[0].arn : null
}

output "grafana_irsa_subject" {
  description = "Kubernetes service account subject used by Grafana IRSA trust policy."
  value       = var.enable_grafana_irsa ? module.grafana_irsa[0].service_account_subject : null
}

output "fluentbit_irsa_role_arn" {
  description = "Fluent Bit CloudWatch Logs write IRSA Role ARN. enable_fluentbit_irsa = false 이면 null 반환"
  value       = var.enable_fluentbit_irsa ? module.fluentbit_irsa[0].role_arn : null
}

output "fluentbit_irsa_role_name" {
  description = "Fluent Bit IRSA Role 이름. enable_fluentbit_irsa = false 이면 null 반환"
  value       = var.enable_fluentbit_irsa ? module.fluentbit_irsa[0].role_name : null
}

output "fluentbit_cloudwatch_write_policy_arn" {
  description = "Fluent Bit CloudWatch Logs write 전용 IAM Policy ARN. enable_fluentbit_irsa = false 이면 null 반환"
  value       = var.enable_fluentbit_irsa ? aws_iam_policy.fluentbit_cloudwatch_write[0].arn : null
}

output "yace_cloudwatch_read_policy_arn" {
  description = "YACE CloudWatch metrics read IAM Policy ARN. enable_yace_irsa = false 이면 null 반환"
  value       = var.enable_yace_irsa ? aws_iam_policy.yace_cloudwatch_read[0].arn : null
}

output "yace_irsa_role_arn" {
  description = "IAM role ARN for YACE IRSA."
  value       = var.enable_yace_irsa ? module.yace_irsa[0].role_arn : null
}

output "yace_irsa_role_name" {
  description = "IAM role name for YACE IRSA."
  value       = var.enable_yace_irsa ? module.yace_irsa[0].role_name : null
}

output "yace_irsa_subject" {
  description = "Kubernetes service account subject used by YACE IRSA trust policy."
  value       = var.enable_yace_irsa ? local.yace_irsa_subject : null
}

output "irsa_role_arns" {
  description = "생성된 IRSA Role ARN 전체 map. 활성화된 Role만 포함"
  value = {
    prometheus = var.enable_prometheus_irsa ? module.prometheus_irsa[0].role_arn : null
    grafana    = var.enable_grafana_irsa ? module.grafana_irsa[0].role_arn : null
    fluentbit  = var.enable_fluentbit_irsa ? module.fluentbit_irsa[0].role_arn : null
    yace       = var.enable_yace_irsa ? module.yace_irsa[0].role_arn : null
  }
}
