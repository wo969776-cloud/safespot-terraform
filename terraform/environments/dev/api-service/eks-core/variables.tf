variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "ap-northeast-2"
}

variable "project" {
  description = "Project name."
  type        = string
  default     = "safespot"
}

variable "env" {
  description = "Environment name."
  type        = string
}

variable "remote_state_bucket" {
  description = "S3 bucket name for Terraform remote state."
  type        = string
  default     = "safespot-terraform-state"
}

variable "network_state_key" {
  description = "S3 object key for network Terraform state."
  type        = string
  default     = "environments/dev/network/terraform.tfstate"
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for EKS."
  type        = string
  default     = "1.34"
}

variable "cluster_endpoint_public_access" {
  description = "Whether to expose EKS API endpoint publicly."
  type        = bool
  default     = true
}

variable "node_instance_types" {
  description = "Instance types for the default EKS managed node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_min_size" {
  description = "Minimum node count."
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum node count."
  type        = number
  default     = 3
}

variable "node_desired_size" {
  description = "Desired node count."
  type        = number
  default     = 1
}
