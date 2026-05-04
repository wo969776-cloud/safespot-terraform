# modules/ops/observability-iam/outputs.tf

# ── CloudWatch 읽기 Policy ────────────────────────────────────────────────────

output "cloudwatch_read_policy_arn" {
  description = <<-EOT
    CloudWatch 읽기 전용 IAM Policy ARN.
    Grafana, Prometheus CloudWatch exporter IRSA Role에 공통 attach.
    enable_grafana_irsa 또는 enable_prometheus_irsa = true 시 자동 attach됨.
    추가로 다른 Role에 attach가 필요하면 이 ARN을 사용.
  EOT
  value = aws_iam_policy.cloudwatch_read.arn
}

# ── Prometheus IRSA ───────────────────────────────────────────────────────────

output "prometheus_irsa_role_arn" {
  description = <<-EOT
    Prometheus CloudWatch exporter IRSA Role ARN.
    enable_prometheus_irsa = false 이면 null 반환.

    observability Helm chart values.yaml 설정 방법:
      prometheus:
        serviceAccount:
          annotations:
            eks.amazonaws.com/role-arn: <이 값>
  EOT
  value = var.enable_prometheus_irsa ? aws_iam_role.prometheus[0].arn : null
}

output "prometheus_irsa_role_name" {
  description = "Prometheus IRSA Role 이름. enable_prometheus_irsa = false 이면 null 반환."
  value       = var.enable_prometheus_irsa ? aws_iam_role.prometheus[0].name : null
}

# ── Grafana IRSA ──────────────────────────────────────────────────────────────

output "grafana_irsa_role_arn" {
  description = <<-EOT
    Grafana CloudWatch datasource IRSA Role ARN.
    enable_grafana_irsa = false 이면 null 반환.

    observability Helm chart values.yaml 설정 방법:
      grafana:
        serviceAccount:
          annotations:
            eks.amazonaws.com/role-arn: <이 값>
  EOT
  value = var.enable_grafana_irsa ? aws_iam_role.grafana[0].arn : null
}

output "grafana_irsa_role_name" {
  description = "Grafana IRSA Role 이름. enable_grafana_irsa = false 이면 null 반환."
  value       = var.enable_grafana_irsa ? aws_iam_role.grafana[0].name : null
}

# ── Fluent Bit IRSA ───────────────────────────────────────────────────────────

output "fluentbit_irsa_role_arn" {
  description = <<-EOT
    Fluent Bit CloudWatch Logs write IRSA Role ARN.
    enable_fluentbit_irsa = false 이면 null 반환.

    logging Helm chart values.yaml 설정 방법:
      serviceAccount:
        annotations:
          eks.amazonaws.com/role-arn: <이 값>
  EOT
  value = var.enable_fluentbit_irsa ? aws_iam_role.fluentbit[0].arn : null
}

output "fluentbit_irsa_role_name" {
  description = "Fluent Bit IRSA Role 이름. enable_fluentbit_irsa = false 이면 null 반환."
  value       = var.enable_fluentbit_irsa ? aws_iam_role.fluentbit[0].name : null
}

output "fluentbit_cloudwatch_write_policy_arn" {
  description = <<-EOT
    Fluent Bit CloudWatch Logs write 전용 IAM Policy ARN.
    enable_fluentbit_irsa = false 이면 null 반환.
    추가 Fluent Bit Role이 필요할 경우 이 ARN을 직접 attach.
  EOT
  value = var.enable_fluentbit_irsa ? aws_iam_policy.fluentbit_cloudwatch_write[0].arn : null
}

# ── 전체 요약 ─────────────────────────────────────────────────────────────────

output "irsa_role_arns" {
  description = <<-EOT
    생성된 IRSA Role ARN 전체 map.
    활성화된 Role만 포함. 비활성 항목은 null.
    environments/dev/ops/outputs.tf 에서 노출해서
    observability/logging Helm chart values 설정 시 참조.
  EOT
  value = {
    prometheus = var.enable_prometheus_irsa ? aws_iam_role.prometheus[0].arn : null
    grafana    = var.enable_grafana_irsa ? aws_iam_role.grafana[0].arn : null
    fluentbit  = var.enable_fluentbit_irsa ? aws_iam_role.fluentbit[0].arn : null
  }
}