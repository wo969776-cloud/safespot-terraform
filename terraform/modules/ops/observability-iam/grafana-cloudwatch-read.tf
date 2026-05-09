# modules/ops/observability-iam/grafana-cloudwatch-read.tf
#
# Grafana CloudWatch datasource가 CloudWatch Metrics / Logs를 조회하기 위한
# 읽기 전용 IAM Policy.
#
# 사용 주체:
# - Grafana ServiceAccount IRSA
#
# Prometheus용이 아님.

resource "aws_iam_policy" "grafana_cloudwatch_read" {
  count = var.enable_grafana_irsa ? 1 : 0

  name        = "${local.name_prefix}-grafana-cloudwatch-read"
  description = "Grafana CloudWatch datasource read-only policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
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
          "cloudwatch:GetInsightRuleReport"
        ]
        Resource = "*"
      },
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
          "logs:FilterLogEvents"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowEC2MetadataRead"
        Effect = "Allow"
        Action = [
          "ec2:DescribeTags",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowTagRead"
        Effect = "Allow"
        Action = [
          "tag:GetResources"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name    = "${local.name_prefix}-grafana-cloudwatch-read"
    Purpose = "grafana-cloudwatch-datasource"
  }
}