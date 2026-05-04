output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Private App subnet IDs (EKS)"
  value       = module.vpc.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Private DB subnet IDs (RDS, Redis)"
  value       = module.vpc.private_db_subnet_ids
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr
}

output "alb_sg_id" {
  value = module.sg.alb_sg_id
}

output "eks_cluster_sg_id" {
  value = module.sg.eks_cluster_sg_id
}

output "eks_node_sg_id" {
  value = module.sg.eks_node_sg_id
}

output "rds_sg_id" {
  value = module.sg.rds_sg_id
}

output "redis_sg_id" {
  value = module.sg.redis_sg_id
}

output "lambda_sg_id" {
  description = "Lambda Security Group ID"
  value       = module.sg.lambda_sg_id
}

