output "cluster_name" {
  description = "EKS cluster name."
  value       = module.eks_core.cluster_name
}

output "cluster_arn" {
  description = "EKS cluster ARN."
  value       = module.eks_core.cluster_arn
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint."
  value       = module.eks_core.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "EKS cluster security group ID."
  value       = module.eks_core.cluster_security_group_id
}

output "node_security_group_id" {
  description = "EKS node security group ID."
  value       = module.eks_core.node_security_group_id
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN."
  value       = module.eks_core.oidc_provider_arn
}

output "oidc_provider" {
  description = "OIDC provider URL without https:// prefix."
  value       = module.eks_core.oidc_provider
}
