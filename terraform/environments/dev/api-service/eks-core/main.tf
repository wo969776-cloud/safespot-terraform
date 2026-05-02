locals {
  common_tags = {
    Project     = "safespot"
    Environment = var.env
    Domain      = "api-service"
    Component   = "eks-core"
    ManagedBy   = "terraform"
  }

  vpc_id                 = data.terraform_remote_state.network.outputs.vpc_id
  private_app_subnet_ids = data.terraform_remote_state.network.outputs.private_app_subnet_ids
}

module "eks_core" {
  source = "../../../../modules/api-service/eks-core"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id                   = local.vpc_id
  private_subnet_ids       = local.private_app_subnet_ids
  control_plane_subnet_ids = local.private_app_subnet_ids

  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  node_instance_types = var.node_instance_types
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size
  node_desired_size   = var.node_desired_size

  tags = local.common_tags
}
