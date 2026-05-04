locals {
  domain    = "api-service"
  component = "eks-addons-irsa"

  cluster_name      = data.terraform_remote_state.eks_core.outputs.cluster_name
  oidc_provider_arn = data.terraform_remote_state.eks_core.outputs.oidc_provider_arn
  oidc_provider     = data.terraform_remote_state.eks_core.outputs.oidc_provider

  external_dns_role_name   = "${var.project}-${var.env}-external-dns-irsa"
  external_dns_policy_name = "${var.project}-${var.env}-external-dns-policy"

  external_secrets_role_name   = "${var.project}-${var.env}-external-secrets-irsa"
  external_secrets_policy_name = "${var.project}-${var.env}-external-secrets-policy"

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
