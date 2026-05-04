output "cloudwatch_read_policy_arn" {
  description = "CloudWatch 읽기 전용 IAM Policy ARN"
  value       = aws_iam_policy.cloudwatch_read.arn
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
  description = "Grafana CloudWatch datasource IRSA Role ARN. enable_grafana_irsa = false 이면 null 반환"
  value       = var.enable_grafana_irsa ? module.grafana_irsa[0].role_arn : null
}

output "grafana_irsa_role_name" {
  description = "Grafana IRSA Role 이름. enable_grafana_irsa = false 이면 null 반환"
  value       = var.enable_grafana_irsa ? module.grafana_irsa[0].role_name : null
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

output "irsa_role_arns" {
  description = "생성된 IRSA Role ARN 전체 map. 활성화된 Role만 포함"
  value = {
    prometheus = var.enable_prometheus_irsa ? module.prometheus_irsa[0].role_arn : null
    grafana    = var.enable_grafana_irsa ? module.grafana_irsa[0].role_arn : null
    fluentbit  = var.enable_fluentbit_irsa ? module.fluentbit_irsa[0].role_arn : null
  }
}