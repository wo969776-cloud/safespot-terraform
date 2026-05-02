module "eks_karpenter" {
  source = "../../../../modules/api-service/eks-karpenter"

  cluster_name      = local.cluster_name
  oidc_provider_arn = local.oidc_provider_arn

  namespace            = var.karpenter_namespace
  service_account_name = var.karpenter_service_account_name

  controller_role_name   = local.karpenter_controller_role_name
  controller_policy_name = local.karpenter_controller_policy_name
  node_role_name         = local.karpenter_node_role_name
  queue_name             = local.karpenter_queue_name

  enable_spot_termination = var.enable_spot_termination
  enable_v1_permissions   = true

  tags = local.common_tags
}
