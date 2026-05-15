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

variable "argocd_values" {
  description = "Additional Helm values for ArgoCD as a YAML string."
  type        = string
  default     = ""
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

variable "root_app_name" {
  description = "Name of the ArgoCD root Application."
  type        = string
  default     = "platform-addons"
}

variable "addons_path_exclude" {
  description = "Filename to exclude from the addons path directory scan."
  type        = string
  default     = "root-platform-addons.yaml"
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
