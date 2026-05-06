module "eks_sg_rules" {
  source = "../../../../modules/api-service/eks-sg-rules"

  cluster_primary_security_group_id = local.cluster_primary_sg_id
  node_security_group_id            = local.node_security_group_id
  alb_security_group_id             = local.alb_security_group_id

  app_port = var.app_port

  vpc_dns_resolver_cidr = local.vpc_dns_resolver_cidr

  endpoint_security_group_ids = local.endpoint_security_group_ids

  enable_alb_app_ingress        = var.enable_alb_app_ingress
  enable_alb_nodeport_ingress   = var.enable_alb_nodeport_ingress
  enable_node_https_to_internet = var.enable_node_https_to_internet

  tags = local.common_tags
}
