locals {
  domain    = "api-service"
  component = "eks-argocd-bootstrap"

  cluster_name = data.terraform_remote_state.eks_core.outputs.cluster_name

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
