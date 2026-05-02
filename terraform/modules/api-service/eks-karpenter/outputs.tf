output "controller_role_name" {
  description = "Karpenter controller IAM role name."
  value       = module.karpenter.iam_role_name
}

output "controller_role_arn" {
  description = "Karpenter controller IAM role ARN."
  value       = module.karpenter.iam_role_arn
}

output "node_role_name" {
  description = "Karpenter node IAM role name."
  value       = module.karpenter.node_iam_role_name
}

output "node_role_arn" {
  description = "Karpenter node IAM role ARN."
  value       = module.karpenter.node_iam_role_arn
}

output "queue_name" {
  description = "Karpenter interruption queue name."
  value       = module.karpenter.queue_name
}

output "queue_arn" {
  description = "Karpenter interruption queue ARN."
  value       = module.karpenter.queue_arn
}

output "instance_profile_name" {
  description = "Karpenter node instance profile name."
  value       = module.karpenter.instance_profile_name
}
