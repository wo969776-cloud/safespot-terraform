# modules/ops/observability-iam/fluentbit-cloudwatch-write.tf
#
# Fluent Bit이 EKS / Application 로그를 CloudWatch Logs로 전송하기 위한
# write 전용 IAM Policy.
#
# 사용 주체:
# - Fluent Bit ServiceAccount IRSA
#
# 로그 수집 흐름:
# Pod stdout/stderr
#   ↓
# Fluent Bit DaemonSet
#   ↓
# CloudWatch Logs
#
# 최소 권한 원칙:
# - 실제 Log Group ARN만 허용
# - 전체 "*" write 권한 사용 금지

resource "aws_iam_policy" "fluentbit_cloudwatch_write" {
  count = var.enable_fluentbit_irsa ? 1 : 0

  name        = "${local.name_prefix}-fluentbit-cloudwatch-write"
  description = "Fluent Bit CloudWatch Logs write policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudWatchLogsWrite"
        Effect = "Allow"

        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]

        Resource = flatten([
          for arn in local.fluentbit_log_group_arns : [
            arn,
            "${arn}:*"
          ]
        ])
      },

      # 선택:
      # Fluent Bit이 자동으로 Log Group 생성해야 하는 경우만 사용
      {
        Sid    = "AllowCreateLogGroup"
        Effect = "Allow"

        Action = [
          "logs:CreateLogGroup"
        ]

        Resource = "*"
      }
    ]
  })

  tags = {
    Name    = "${local.name_prefix}-fluentbit-cloudwatch-write"
    Purpose = "fluentbit-cloudwatch-logs"
  }
}