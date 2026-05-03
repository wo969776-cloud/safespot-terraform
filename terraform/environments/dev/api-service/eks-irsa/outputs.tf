output "source_eks_core_state_key" {
  description = "S3 state key used as eks-core remote state source."
  value       = var.eks_core_state_key
}

output "cluster_name" {
  description = "EKS cluster name from eks-core remote state."
  value       = local.cluster_name
}

output "alb_controller_policy_arn" {
  description = "IAM policy ARN for AWS Load Balancer Controller."
  value       = aws_iam_policy.alb_controller.arn
}

output "alb_controller_irsa_role_name" {
  description = "IAM role name for AWS Load Balancer Controller IRSA."
  value       = module.alb_controller_irsa.role_name
}

output "alb_controller_irsa_role_arn" {
  description = "IAM role ARN for AWS Load Balancer Controller IRSA."
  value       = module.alb_controller_irsa.role_arn
}

output "alb_controller_service_account_subject" {
  description = "Kubernetes service account subject for AWS Load Balancer Controller."
  value       = module.alb_controller_irsa.service_account_subject
}

output "alb_controller_namespace" {
  description = "Kubernetes namespace for AWS Load Balancer Controller."
  value       = var.alb_controller_namespace
}

output "alb_controller_service_account_name" {
  description = "Kubernetes ServiceAccount name for AWS Load Balancer Controller."
  value       = var.alb_controller_service_account_name
}
