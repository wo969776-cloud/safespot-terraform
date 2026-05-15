locals {
  domain    = "api-service"
  component = "eks-addons"

  cluster_name          = data.terraform_remote_state.eks_core.outputs.cluster_name
  ebs_csi_irsa_role_arn = data.terraform_remote_state.eks_addons_irsa.outputs.ebs_csi_irsa_role_arn

  common_tags = {
    Project     = var.project
    Environment = var.environment
    Domain      = local.domain
    Component   = local.component
    ManagedBy   = "terraform"
    Service     = var.project
    CostCenter  = "${var.project}-${var.environment}"
  }
}
