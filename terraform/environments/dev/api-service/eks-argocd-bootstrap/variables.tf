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

variable "eks_core_state_key" {
  description = "S3 object key for EKS core Terraform state."
  type        = string
  default     = "environments/dev/api-service/eks-core/terraform.tfstate"
}

variable "argocd_namespace" {
  description = "Kubernetes namespace for ArgoCD."
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "ArgoCD Helm chart version."
  type        = string
  default     = "7.6.12"
}

variable "repo_url" {
  description = "Git repository URL for ArgoCD root Application."
  type        = string
}

variable "target_revision" {
  description = "Git branch or commit for ArgoCD root Application."
  type        = string
  default     = "infra/api-service"
}

variable "addons_path" {
  description = "Path in the repository containing add-on ArgoCD Application manifests."
  type        = string
  default     = "argocd"
}

variable "argocd_node_selector" {
  description = "Node selector applied to all ArgoCD components to pin them to system nodes."
  type        = map(string)
  default = {
    "safespot.io/node-group" = "ops"
  }
}

variable "argocd_tolerations" {
  description = "Tolerations applied to all ArgoCD components for the system node taint."
  type = list(object({
    key      = string
    operator = string
    value    = optional(string)
    effect   = string
  }))
  default = [
    {
      key      = "safespot.io/dedicated"
      operator = "Equal"
      value    = "ops"
      effect   = "NoSchedule"
    }
  ]
}
