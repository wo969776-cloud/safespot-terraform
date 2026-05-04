module "grafana_irsa" {
  count  = var.enable_grafana_irsa ? 1 : 0
  source = "../../../../modules/api-service/eks-irsa"

  role_name            = "${local.name_prefix}-grafana-irsa"
  oidc_provider_arn    = var.eks_oidc_provider_arn
  oidc_provider        = var.eks_oidc_provider_url
  namespace            = var.grafana_namespace
  service_account_name = var.grafana_service_account_name

  managed_policy_arns = [
    aws_iam_policy.cloudwatch_read.arn
  ]
}