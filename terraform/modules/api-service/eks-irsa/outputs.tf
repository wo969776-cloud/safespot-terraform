output "role_name" {
  description = "IAM role name."
  value       = aws_iam_role.this.name
}

output "role_arn" {
  description = "IAM role ARN."
  value       = aws_iam_role.this.arn
}

output "service_account_subject" {
  description = "Kubernetes service account subject used in IRSA trust policy."
  value       = local.service_account_subject
}

output "namespace" {
  description = "Kubernetes namespace."
  value       = var.namespace
}

output "service_account_name" {
  description = "Kubernetes service account name."
  value       = var.service_account_name
}
