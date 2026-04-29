variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_app_subnet_ids" {
  description = "Private App Subnet IDs"
  type        = list(string)
}

variable "private_app_route_table_ids" {
  description = "Private App Route Table IDs (S3 Gateway Endpoint용)"
  type        = list(string)
}

variable "eks_node_sg_id" {
  description = "EKS Node Security Group ID"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}