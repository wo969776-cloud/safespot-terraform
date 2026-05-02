variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "oidc_provider_arn" {
  description = "EKS OIDC provider ARN for Karpenter IRSA."
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for Karpenter controller."
  type        = string
  default     = "kube-system"
}

variable "service_account_name" {
  description = "Kubernetes ServiceAccount name for Karpenter controller."
  type        = string
  default     = "karpenter"
}

variable "controller_role_name" {
  description = "IAM role name for Karpenter controller."
  type        = string
}

variable "controller_policy_name" {
  description = "IAM policy name for Karpenter controller."
  type        = string
}

variable "node_role_name" {
  description = "IAM role name for Karpenter provisioned nodes."
  type        = string
}

variable "queue_name" {
  description = "SQS queue name for Karpenter interruption handling."
  type        = string
}

variable "enable_spot_termination" {
  description = "Whether to enable native spot interruption handling."
  type        = bool
  default     = true
}

variable "enable_v1_permissions" {
  description = "Whether to enable Karpenter v1+ IAM permissions."
  type        = bool
  default     = true
}

variable "node_iam_role_additional_policies" {
  description = "Additional IAM policies to attach to Karpenter node IAM role."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
