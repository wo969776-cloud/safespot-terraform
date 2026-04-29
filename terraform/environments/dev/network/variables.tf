variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "Private App subnet CIDR blocks (EKS)"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "Private DB subnet CIDR blocks (RDS, Redis)"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "app_port" {
  description = "Application port (ALB to EKS node)"
  type        = number
  default     = 8080
} # 수정 가능성 있음 eks