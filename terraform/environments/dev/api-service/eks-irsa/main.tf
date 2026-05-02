resource "aws_iam_policy" "alb_controller" {
  name        = local.alb_controller_policy_name
  description = "IAM policy for AWS Load Balancer Controller on ${local.cluster_name}."
  policy      = file("${path.module}/policies/aws-load-balancer-controller-policy.json")

  tags = merge(local.common_tags, {
    Name      = local.alb_controller_policy_name
    Workload  = "aws-load-balancer-controller"
    Namespace = var.alb_controller_namespace
  })
}

module "alb_controller_irsa" {
  source = "../../../../modules/api-service/eks-irsa"

  role_name            = local.alb_controller_role_name
  oidc_provider_arn    = local.oidc_provider_arn
  oidc_provider        = local.oidc_provider
  namespace            = var.alb_controller_namespace
  service_account_name = var.alb_controller_service_account_name

  managed_policy_arns = [
    aws_iam_policy.alb_controller.arn
  ]

  tags = local.common_tags
}
