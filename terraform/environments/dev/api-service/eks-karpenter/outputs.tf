output "cluster_name" {
  description = "EKS cluster name from eks-core remote state."
  value       = local.cluster_name
}

output "karpenter_controller_role_name" {
  description = "Karpenter controller IAM role name."
  value       = module.eks_karpenter.controller_role_name
}

output "karpenter_controller_role_arn" {
  description = "Karpenter controller IAM role ARN."
  value       = module.eks_karpenter.controller_role_arn
}

output "karpenter_node_role_name" {
  description = "Karpenter node IAM role name."
  value       = module.eks_karpenter.node_role_name
}

output "karpenter_node_role_arn" {
  description = "Karpenter node IAM role ARN."
  value       = module.eks_karpenter.node_role_arn
}

output "karpenter_queue_name" {
  description = "Karpenter interruption queue name."
  value       = module.eks_karpenter.queue_name
}

output "karpenter_queue_arn" {
  description = "Karpenter interruption queue ARN."
  value       = module.eks_karpenter.queue_arn
}

output "karpenter_instance_profile_name" {
  description = "Karpenter node instance profile name."
  value       = module.eks_karpenter.instance_profile_name
}
