variable "role_name" {
  description = "IAM role name for the Kubernetes service account."
  type        = string
}

variable "oidc_provider_arn" {
  description = "EKS OIDC provider ARN."
  type        = string
}

variable "oidc_provider" {
  description = "EKS OIDC provider URL without https:// prefix."
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace of the service account."
  type        = string
}

variable "service_account_name" {
  description = "Kubernetes service account name."
  type        = string
}

variable "managed_policy_arns" {
  description = "Managed policy ARNs to attach to the IRSA role. Map keys must be static."
  type        = map(string)
  default     = {}
}

variable "inline_policy_json" {
  description = "Optional inline IAM policy JSON for the IRSA role."
  type        = string
  default     = null

  validation {
    condition     = var.inline_policy_json == null || can(jsondecode(var.inline_policy_json))
    error_message = "inline_policy_json must be valid JSON when provided."
  }
}

variable "tags" {
  description = "Common tags for resources."
  type        = map(string)
  default     = {}
}
