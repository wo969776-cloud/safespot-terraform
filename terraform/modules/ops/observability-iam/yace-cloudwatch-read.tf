 # modules/ops/observability-iam/yace-cloudwatch-read.tf
#
# YACE(Yet Another CloudWatch Exporter)가 AWS CloudWatch Metrics를
# Prometheus metric 형태로 export하기 위한 읽기 전용 IAM Policy.
#
# 사용 주체:
# - YACE ServiceAccount IRSA
#
# Grafana Logs 조회 권한은 포함하지 않는다.

resource "aws_iam_policy" "yace_cloudwatch_read" {
  count = var.enable_yace_irsa ? 1 : 0

  name        = "${local.name_prefix}-yace-cloudwatch-read"
  description = "YACE CloudWatch metrics read-only policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudWatchMetricsRead"
        Effect = "Allow"
        Action = [
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics"
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
      },
      {
        Sid    = "AllowResourceGroupTaggingRead"
        Effect = "Allow"
        Action = [
          "tag:GetTagKeys",
          "tag:GetTagValues"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name    = "${local.name_prefix}-yace-cloudwatch-read"
    Purpose = "yace-cloudwatch-exporter"
  }
}