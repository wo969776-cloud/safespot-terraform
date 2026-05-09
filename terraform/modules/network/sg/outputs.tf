output "alb_sg_id" {
  description = "ALB Security Group ID"
  value       = aws_security_group.alb.id
}

output "eks_node_sg_id" {
  description = "EKS Node Security Group ID"
  value       = aws_security_group.eks_node.id
}

output "rds_sg_id" {
  description = "RDS Security Group ID"
  value       = aws_security_group.rds.id
}

output "redis_sg_id" {
  description = "Redis Security Group ID"
  value       = aws_security_group.redis.id
}

output "lambda_sg_id" {
  description = "Lambda Security Group ID"
  value       = aws_security_group.lambda.id
}