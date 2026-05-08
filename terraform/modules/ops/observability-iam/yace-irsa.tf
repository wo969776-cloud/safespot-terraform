resource "aws_iam_policy" "yace_cloudwatch_read" {
  count = var.enable_yace_irsa ? 1 : 0

  name        = "${local.name_prefix}-observability-yace-cloudwatch-read"
  description = "YACE CloudWatch metrics read permissions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CloudWatchMetricsRead"
        Effect = "Allow"
        Action = [
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics"
        ]
        Resource = "*"
      },
      {
        Sid    = "ResourceTagDiscovery"
        Effect = "Allow"
        Action = [
          "tag:GetResources"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name    = "${local.name_prefix}-observability-yace-cloudwatch-read"
    Purpose = "yace-cloudwatch-metrics-read"
  }
}

module "yace_irsa" {
  count  = var.enable_yace_irsa ? 1 : 0
  source = "../../../modules/api-service/eks-irsa"

  role_name            = "${local.name_prefix}-observability-yace-irsa"
  oidc_provider_arn    = var.eks_oidc_provider_arn
  oidc_provider        = var.eks_oidc_provider_url
  namespace            = var.yace_namespace
  service_account_name = var.yace_service_account_name

  managed_policy_arns = {
    yace_cloudwatch_read = aws_iam_policy.yace_cloudwatch_read[0].arn
  }
}
