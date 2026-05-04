# ============================================================
# ExternalDNS Outputs
# ============================================================
output "external_dns_policy_arn" {
  description = "ARN of the IAM policy for ExternalDNS"
  value       = aws_iam_policy.external_dns.arn
}

output "external_dns_irsa_role_name" {
  description = "Name of the IRSA IAM role for ExternalDNS"
  value       = module.external_dns_irsa.role_name
}

output "external_dns_irsa_role_arn" {
  description = "ARN of the IRSA IAM role for ExternalDNS"
  value       = module.external_dns_irsa.role_arn
}

output "external_dns_service_account_subject" {
  description = "OIDC subject for the ExternalDNS service account"
  value       = module.external_dns_irsa.service_account_subject
}

# ============================================================
# External Secrets Operator Outputs
# ============================================================
output "external_secrets_policy_arn" {
  description = "ARN of the IAM policy for External Secrets Operator"
  value       = aws_iam_policy.external_secrets.arn
}

output "external_secrets_irsa_role_name" {
  description = "Name of the IRSA IAM role for External Secrets Operator"
  value       = module.external_secrets_irsa.role_name
}

output "external_secrets_irsa_role_arn" {
  description = "ARN of the IRSA IAM role for External Secrets Operator"
  value       = module.external_secrets_irsa.role_arn
}

output "external_secrets_service_account_subject" {
  description = "OIDC subject for the External Secrets Operator service account"
  value       = module.external_secrets_irsa.service_account_subject
}
