module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 20.0"

  cluster_name = var.cluster_name

  # Karpenter controller IAM role
  create_iam_role          = true
  iam_role_name            = var.controller_role_name
  iam_role_use_name_prefix = false

  iam_policy_name            = var.controller_policy_name
  iam_policy_use_name_prefix = false

  # IRSA for Karpenter controller
  enable_pod_identity = false
  enable_irsa         = true

  irsa_oidc_provider_arn = var.oidc_provider_arn
  irsa_namespace_service_accounts = [
    "${var.namespace}:${var.service_account_name}"
  ]

  enable_v1_permissions = var.enable_v1_permissions

  # Interruption handling
  enable_spot_termination = var.enable_spot_termination
  queue_name              = var.queue_name

  # Karpenter node role
  create_node_iam_role          = true
  node_iam_role_name            = var.node_role_name
  node_iam_role_use_name_prefix = false

  node_iam_role_additional_policies = var.node_iam_role_additional_policies

  # EKS access entry for Karpenter provisioned nodes
  create_access_entry = true

  # Instance profile for Karpenter provisioned nodes
  create_instance_profile = true

  tags = var.tags
}
