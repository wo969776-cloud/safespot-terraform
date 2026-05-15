variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for EKS."
  type        = string
  default     = "1.34"
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be created."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS managed node groups."
  type        = list(string)
}

variable "control_plane_subnet_ids" {
  description = "Subnet IDs for EKS control plane ENIs. If empty, private_subnet_ids will be used."
  type        = list(string)
  default     = []
}

variable "cluster_endpoint_public_access" {
  description = "Whether to enable public access to the EKS API endpoint."
  type        = bool
  default     = true
}

variable "cluster_endpoint_private_access" {
  description = "Whether to expose EKS API endpoint privately."
  type        = bool
  default     = true
}

variable "node_security_group_id" {
  description = "Existing security group ID for EKS managed node group."
  type        = string
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

variable "tags" {
  description = "Common tags for resources."
  type        = map(string)
  default     = {}
}
