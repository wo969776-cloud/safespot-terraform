# ============================================================
# ExternalDNS IAM Policy
# ============================================================
data "aws_route53_zone" "external_dns" {
  name         = var.external_dns_zone_name
  private_zone = false
}

data "aws_iam_policy_document" "external_dns" {
  statement {
    sid    = "AllowExternalDNSRecordChanges"
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = [
      data.aws_route53_zone.external_dns.arn,
    ]
  }

  statement {
    sid    = "AllowExternalDNSRead"
    effect = "Allow"

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "external_dns" {
  name        = local.external_dns_policy_name
  description = "IAM policy for ExternalDNS to manage Route53 records"
  policy      = data.aws_iam_policy_document.external_dns.json

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
  managed_policy_arns = {
    external_dns = aws_iam_policy.external_dns.arn
  }
  inline_policy_json = null

  tags = local.common_tags
}

# ============================================================
# External Secrets Operator IAM Policy
# ============================================================
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "external_secrets" {
  statement {
    sid    = "SecretsManagerRead"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]

    resources = [
      "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:${var.project}/${var.env}/*",
    ]
  }

  statement {
    sid    = "SSMParameterStoreRead"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
    ]

    resources = [
      "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.project}/${var.env}/*",
    ]
  }
}

resource "aws_iam_policy" "external_secrets" {
  name        = local.external_secrets_policy_name
  description = "IAM policy for External Secrets Operator to access Secrets Manager and SSM Parameter Store"
  policy      = data.aws_iam_policy_document.external_secrets.json

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
  managed_policy_arns = {
    external_secrets = aws_iam_policy.external_secrets.arn
  }
  inline_policy_json = null

  tags = local.common_tags
}
