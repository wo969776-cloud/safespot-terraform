resource "aws_iam_policy" "grafana_cloudwatch_read" {
  count = var.enable_grafana_irsa ? 1 : 0

  name        = "${local.name_prefix}-observability-grafana-cloudwatch-read"
  description = "Grafana CloudWatch datasource metrics read permissions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CloudWatchMetricsRead"
        Effect = "Allow"
        Action = [
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "cloudwatch:DescribeAlarms"
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
    Name    = "${local.name_prefix}-observability-grafana-cloudwatch-read"
    Purpose = "grafana-cloudwatch-datasource"
  }
}

module "grafana_irsa" {
  count  = var.enable_grafana_irsa ? 1 : 0
  source = "../../../modules/api-service/eks-irsa"

  role_name            = "${local.name_prefix}-observability-grafana-irsa"
  oidc_provider_arn    = var.eks_oidc_provider_arn
  oidc_provider        = var.eks_oidc_provider_url
  namespace            = var.grafana_namespace
  service_account_name = var.grafana_service_account_name

  managed_policy_arns = {
    grafana_cloudwatch_read = aws_iam_policy.grafana_cloudwatch_read[0].arn
  }
}
