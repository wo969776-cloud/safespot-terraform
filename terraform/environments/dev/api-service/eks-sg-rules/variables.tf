variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "ap-northeast-2"
}

variable "env" {
  description = "Environment name."
  type        = string
}

variable "project" {
  description = "Project name."
  type        = string
  default     = "safespot"
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

variable "eks_core_state_key" {
  description = "S3 object key for eks-core Terraform state."
  type        = string
  default     = "environments/dev/api-service/eks-core/terraform.tfstate"
}

variable "app_port" {
  description = "Application target port allowed from ALB to nodes."
  type        = number
  default     = 8080
}

variable "enable_alb_app_ingress" {
  description = "Allow ALB to application target port on nodes. Keep false if the network SG module already owns this rule."
  type        = bool
  default     = false
}

variable "enable_alb_nodeport_ingress" {
  description = "Allow ALB to Kubernetes NodePort range when using instance target type."
  type        = bool
  default     = false
}

variable "enable_node_https_to_internet" {
  description = "Allow node outbound HTTPS to the internet via NAT. Keep false if the network SG module already owns this rule."
  type        = bool
  default     = false
}
