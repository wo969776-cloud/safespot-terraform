output "cluster_primary_security_group_id" {
  description = "EKS automatically-created cluster primary security group ID."
  value       = module.eks_sg_rules.cluster_primary_security_group_id
}

output "node_security_group_id" {
  description = "Custom EKS node security group ID."
  value       = module.eks_sg_rules.node_security_group_id
}

output "vpc_dns_resolver_cidr" {
  description = "VPC DNS resolver CIDR used by node DNS egress rules."
  value       = local.vpc_dns_resolver_cidr
}
