output "cluster_primary_security_group_id" {
  description = "EKS automatically-created cluster primary security group ID."
  value       = var.cluster_primary_security_group_id
}

output "node_security_group_id" {
  description = "Custom EKS node security group ID."
  value       = var.node_security_group_id
}
