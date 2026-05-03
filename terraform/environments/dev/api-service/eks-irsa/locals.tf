locals {
  domain    = "api-service"
  component = "eks-irsa"

  cluster_name      = data.terraform_remote_state.eks_core.outputs.cluster_name
  oidc_provider_arn = data.terraform_remote_state.eks_core.outputs.oidc_provider_arn
  oidc_provider     = data.terraform_remote_state.eks_core.outputs.oidc_provider

  alb_controller_role_name   = "${var.project}-${var.env}-api-service-iam-role-alb-controller"
  alb_controller_policy_name = "${var.project}-${var.env}-api-service-iam-policy-alb-controller"

  common_tags = {
    Project     = var.project
    Environment = var.env
    Domain      = local.domain
    Component   = local.component
    ManagedBy   = "terraform"
    Service     = var.project
    CostCenter  = "${var.project}-${var.env}"
  }
}
