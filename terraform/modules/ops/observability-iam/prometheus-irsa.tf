module "prometheus_irsa" {
  count  = var.enable_prometheus_irsa ? 1 : 0
  source = "../../../modules/api-service/eks-irsa"

  role_name            = "${local.name_prefix}-prometheus-irsa"
  oidc_provider_arn    = var.eks_oidc_provider_arn
  oidc_provider        = var.eks_oidc_provider_url
  namespace            = var.prometheus_namespace
  service_account_name = var.prometheus_service_account_name

  managed_policy_arns = {
    cloudwatch_read = aws_iam_policy.cloudwatch_read.arn
  }
}