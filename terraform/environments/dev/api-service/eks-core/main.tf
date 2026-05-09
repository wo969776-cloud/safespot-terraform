module "eks_core" {
  source = "../../../../modules/api-service/eks-core"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id                   = local.vpc_id
  private_subnet_ids       = local.private_app_subnet_ids
  control_plane_subnet_ids = local.private_app_subnet_ids

  node_security_group_id = local.eks_node_sg_id

  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access

  create_managed_node_group = var.create_managed_node_group

  managed_node_groups = var.managed_node_groups

  tags = local.common_tags
}
