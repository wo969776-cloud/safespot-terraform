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

variable "node_instance_types" {
  description = "Instance types for the default EKS managed node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_min_size" {
  description = "Minimum number of nodes in the default managed node group."
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of nodes in the default managed node group."
  type        = number
  default     = 3
}

variable "node_desired_size" {
  description = "Desired number of nodes in the default managed node group."
  type        = number
  default     = 1
}

variable "tags" {
  description = "Common tags for resources."
  type        = map(string)
  default     = {}
}

variable "cluster_security_group_id" {
  description = "Existing security group ID for EKS cluster."
  type        = string
}

variable "node_security_group_id" {
  description = "Existing security group ID for EKS managed node group."
  type        = string
}
