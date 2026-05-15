locals {
  common_tags = {
    Project     = var.project
    Environment = var.env
    Domain      = "api-service"
    Component   = "eks-core"
    ManagedBy   = "terraform"
    Service     = var.project
    CostCenter  = "${var.project}-${var.env}"
  }

  vpc_id                 = data.terraform_remote_state.network.outputs.vpc_id
  private_app_subnet_ids = data.terraform_remote_state.network.outputs.private_app_subnet_ids

  eks_node_sg_id = data.terraform_remote_state.network.outputs.eks_node_sg_id
}
