# ============================================================
# ExternalDNS IAM Policy
# ============================================================
resource "aws_iam_policy" "external_dns" {
  name        = local.external_dns_policy_name
  description = "IAM policy for ExternalDNS to manage Route53 records"
  policy      = file("${path.module}/policies/external-dns-policy.json")

  tags = merge(local.common_tags, {
    Name      = local.external_dns_policy_name
    Workload  = "external-dns"
    Namespace = var.external_dns_namespace
  })
}

# ============================================================
# ExternalDNS IRSA
# ============================================================
module "external_dns_irsa" {
  source = "../../../../modules/api-service/eks-irsa"

  role_name            = local.external_dns_role_name
  oidc_provider_arn    = local.oidc_provider_arn
  oidc_provider        = local.oidc_provider
  namespace            = var.external_dns_namespace
  service_account_name = var.external_dns_service_account_name
  managed_policy_arns  = [aws_iam_policy.external_dns.arn]
  inline_policy_json   = null

  tags = local.common_tags
}

# ============================================================
# External Secrets Operator IAM Policy
# ============================================================
resource "aws_iam_policy" "external_secrets" {
  name        = local.external_secrets_policy_name
  description = "IAM policy for External Secrets Operator to access Secrets Manager and SSM Parameter Store"
  policy      = file("${path.module}/policies/external-secrets-policy.json")

  tags = merge(local.common_tags, {
    Name      = local.external_secrets_policy_name
    Workload  = "external-secrets"
    Namespace = var.external_secrets_namespace
  })
}

# ============================================================
# External Secrets Operator IRSA
# ============================================================
module "external_secrets_irsa" {
  source = "../../../../modules/api-service/eks-irsa"

  role_name            = local.external_secrets_role_name
  oidc_provider_arn    = local.oidc_provider_arn
  oidc_provider        = local.oidc_provider
  namespace            = var.external_secrets_namespace
  service_account_name = var.external_secrets_service_account_name
  managed_policy_arns  = [aws_iam_policy.external_secrets.arn]
  inline_policy_json   = null

  tags = local.common_tags
}
