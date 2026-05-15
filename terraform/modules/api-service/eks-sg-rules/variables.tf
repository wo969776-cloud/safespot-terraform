variable "cluster_primary_security_group_id" {
  description = "EKS automatically-created cluster primary security group ID."
  type        = string
}

variable "node_security_group_id" {
  description = "Custom EKS node security group ID."
  type        = string
}

variable "alb_security_group_id" {
  description = "ALB security group ID."
  type        = string
  default     = null
}

variable "app_port" {
  description = "Application target port allowed from ALB to nodes."
  type        = number
  default     = 8080
}

variable "control_plane_to_node_ports" {
  description = "TCP ports allowed from the EKS control plane primary security group to the node security group."
  type        = map(number)
  default = {
    kubelet       = 10250
    webhook_https = 443
    webhook_8443  = 8443
    webhook_9443  = 9443
  }
}

variable "vpc_dns_resolver_cidr" {
  description = "VPC DNS resolver CIDR. For 10.0.0.0/16 this is usually 10.0.0.2/32."
  type        = string
}

variable "endpoint_security_group_ids" {
  description = "Interface VPC endpoint security group IDs that nodes can access on TCP 443."
  type        = set(string)
  default     = []
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

variable "tags" {
  description = "Tags for security group rules."
  type        = map(string)
  default     = {}
}
