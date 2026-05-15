locals {
  domain    = "api-service"
  component = "eks-sg-rules"

  vpc_cidr                    = data.terraform_remote_state.network.outputs.vpc_cidr
  vpc_dns_resolver_cidr       = "${cidrhost(local.vpc_cidr, 2)}/32"
  node_security_group_id      = data.terraform_remote_state.network.outputs.eks_node_sg_id
  alb_security_group_id       = data.terraform_remote_state.network.outputs.alb_sg_id
  cluster_primary_sg_id       = data.terraform_remote_state.eks_core.outputs.cluster_primary_security_group_id
  endpoint_security_group_ids = []

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
