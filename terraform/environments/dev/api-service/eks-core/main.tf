locals {
  common_tags = {
    Project     = "safespot"
    Environment = var.env
    Domain      = "api-service"
    Component   = "eks-core"
    ManagedBy   = "terraform"
  }
}

module "eks_core" {
  source = "../../../../modules/api-service/eks-core"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id                   = var.vpc_id
  private_subnet_ids       = var.private_subnet_ids
  control_plane_subnet_ids = var.control_plane_subnet_ids

  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  node_instance_types = var.node_instance_types
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size
  node_desired_size   = var.node_desired_size

  tags = local.common_tags
}
