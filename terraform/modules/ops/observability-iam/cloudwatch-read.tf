# modules/ops/observability-iam/cloudwatch-read.tf
#
# monitoring.md 섹션 1:
#   Dashboard / alert → Grafana + AlertManager, CloudWatch Alarm 병행
#
# Prometheus CloudWatch exporter가 사용할 수 있는
# 읽기 전용 IAM Policy를 정의한다.
#
# 이 Policy는:
# Grafana CloudWatch datasource는 별도 최소 권한 policy를 사용한다.

resource "aws_iam_policy" "cloudwatch_read" {
  count = var.enable_prometheus_irsa ? 1 : 0

  name        = "${local.name_prefix}-cloudwatch-read"
  description = "Prometheus CloudWatch exporter 읽기 전용 권한"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # ── CloudWatch Metrics 읽기 ────────────────────────────────────────────
      # Grafana CloudWatch datasource, Prometheus CloudWatch exporter 공통 필요
      {
        Sid    = "AllowCloudWatchMetricsRead"
        Effect = "Allow"
        Action = [
          "cloudwatch:DescribeAlarmsForMetric",
          "cloudwatch:DescribeAlarmHistory",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:GetInsightRuleReport",
        ]
        Resource = "*"
        # TODO: Resource를 특정 namespace로 제한하려면
        #       Condition으로 cloudwatch:namespace를 지정할 수 있음
        #       현재는 전체 허용 (Grafana datasource 특성상 namespace 제한이 어려움)
      },

      # ── CloudWatch Logs 읽기 ───────────────────────────────────────────────
      # Grafana Logs 패널에서 CloudWatch Logs 조회 시 필요
      {
        Sid    = "AllowCloudWatchLogsRead"
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents",
          "logs:GetLogGroupFields",
          "logs:GetLogRecord",
          "logs:GetQueryResults",
          "logs:StartQuery",
          "logs:StopQuery",
          "logs:FilterLogEvents",
        ]
        Resource = "*"
        # TODO: Resource를 log-groups 모듈의 ARN 목록으로 제한하면
        #       최소 권한 원칙을 지킬 수 있음
        #       Grafana Logs 패널에서 특정 Log Group만 조회한다면
        #       해당 ARN만 지정할 것
      },

      # ── EC2/Tag 메타데이터 읽기 ───────────────────────────────────────────
      # Grafana CloudWatch datasource가 리전/계정 정보 조회 시 필요
      {
        Sid    = "AllowEC2TagRead"
        Effect = "Allow"
        Action = [
          "ec2:DescribeTags",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
        ]
        Resource = "*"
      },

      # ── 태그 기반 리소스 조회 ─────────────────────────────────────────────
      # Grafana CloudWatch datasource dimension 자동완성 시 필요
      {
        Sid    = "AllowTagRead"
        Effect = "Allow"
        Action = [
          "tag:GetResources",
        ]
        Resource = "*"
      },
    ]
  })

  tags = {
    Name    = "${local.name_prefix}-cloudwatch-read"
    Purpose = "grafana-prometheus-cloudwatch-datasource"
  }
}
