resource "aws_iam_policy" "fluentbit_cloudwatch_write" {
  count = var.enable_fluentbit_irsa ? 1 : 0

  name        = "${local.name_prefix}-fluentbit-cloudwatch-write"
  description = "Fluent Bit CloudWatch Logs write 전용 최소 권한 정책"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowLogStreamWrite"
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = [
          for arn in local.fluentbit_log_group_arns :
          "${arn}:*"
        ]
      },
      {
        Sid    = "AllowLogGroupDescribe"
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name      = "${local.name_prefix}-fluentbit-cloudwatch-write"
    Component = "fluent-bit"
    Purpose   = "cloudwatch-logs-write-only"
  }
}

module "fluentbit_irsa" {
  count  = var.enable_fluentbit_irsa ? 1 : 0
  source = "../../../modules/api-service/eks-irsa"

  role_name            = "${local.name_prefix}-fluentbit-irsa"
  oidc_provider_arn    = var.eks_oidc_provider_arn
  oidc_provider        = var.eks_oidc_provider_url
  namespace            = var.fluentbit_namespace
  service_account_name = var.fluentbit_service_account_name

  managed_policy_arns = {
    fluentbit_cloudwatch_write = aws_iam_policy.fluentbit_cloudwatch_write[0].arn
  }
}

resource "aws_ssm_parameter" "fluentbit_irsa_role_arn" {
  count = var.enable_fluentbit_irsa ? 1 : 0

  name        = "/${var.project}/${var.environment}/observability/fluentbit/irsa-role-arn"
  description = "Fluent Bit IRSA Role ARN for CloudWatch Logs write"
  type        = "String"
  value       = module.fluentbit_irsa[0].role_arn

  overwrite = true

  tags = {
    Name      = "/${var.project}/${var.environment}/observability/fluentbit/irsa-role-arn"
    Component = "fluent-bit"
    Purpose   = "fluentbit-irsa-role-arn"
  }
}