# Terraform이 파라미터를 생성하고 이름을 확정합니다.
# 실제 Webhook URL은 콘솔 또는 CLI에서 직접 입력하세요 (Type: SecureString).
# aws ssm put-parameter \
#   --name "$(terraform output -raw slack_webhook_secret_name)" \
#   --value "https://hooks.slack.com/services/..." \
#   --type "SecureString" --overwrite

resource "aws_ssm_parameter" "slack_webhook" {
  count = var.enable_slack_secret ? 1 : 0

  name  = "/${local.slack_secret_name}"
  type  = "SecureString"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_iam_policy" "alertmanager_secret_read" {
  count = var.enable_slack_secret ? 1 : 0

  name = "${local.name_prefix}-alertmanager-secret-read"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowSSMParameterRead"
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:DescribeParameters"
        ]
        Resource = aws_ssm_parameter.slack_webhook[0].arn
      }
    ]
  })
}
