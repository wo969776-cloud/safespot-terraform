locals {
  domain    = "api-service"
  component = "eks-karpenter"

  cluster_name      = data.terraform_remote_state.eks_core.outputs.cluster_name
  oidc_provider_arn = data.terraform_remote_state.eks_core.outputs.oidc_provider_arn

  karpenter_controller_role_name   = "${var.project}-${var.env}-karpenter-controller"
  karpenter_controller_policy_name = "${var.project}-${var.env}-karpenter-controller"
  karpenter_node_role_name         = "${var.project}-${var.env}-karpenter-node"
  karpenter_queue_name             = "${var.project}-${var.env}-karpenter"

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
