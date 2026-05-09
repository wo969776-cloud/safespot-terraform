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

variable "remote_state_bucket" {
  description = "S3 bucket name for Terraform remote state"
  type        = string
  default     = "safespot-terraform-state"
}

variable "eks_core_state_key" {
  description = "S3 object key for EKS core Terraform state"
  type        = string
  default     = "environments/dev/api-service/eks-core/terraform.tfstate"
}

variable "eks_addons_irsa_state_key" {
  description = "S3 object key for EKS addons IRSA Terraform state"
  type        = string
  default     = "environments/dev/api-service/eks-addons-irsa/terraform.tfstate"
}
