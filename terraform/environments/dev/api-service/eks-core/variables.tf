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

variable "cluster_endpoint_private_access" {
  description = "Whether to expose EKS API endpoint privately."
  type        = bool
  default     = true
}

variable "create_managed_node_group" {
  description = "Whether to create EKS managed node groups. Set false for the first cluster-only bootstrap apply, then true after eks-sg-rules is applied."
  type        = bool
  default     = true
}

variable "managed_node_groups" {
  description = "Map of EKS managed node group configurations."
  type = map(object({
    name           = string
    instance_types = list(string)
    iam_role_name  = string
    min_size       = number
    max_size       = number
    desired_size   = number
    labels         = optional(map(string), {})
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
  }))
  default = {}
}
