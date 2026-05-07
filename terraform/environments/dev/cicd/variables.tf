variable "aws_region" {
  type    = string
  default = "ap-northeast-2"
}

variable "project" {
  type    = string
  default = "safespot"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "github_org" {
  type    = string
  default = "project-safespot"
}

variable "github_repos" {
  type = list(string)

  default = [
    "safespot-terraform",
    "safespot-application"
  ]
}

variable "allowed_branches" {
  type = list(string)
}

variable "terraform_state_bucket" {
  type    = string
  default = "safespot-terraform-state"
}

variable "ecr_repository_arns" {
  type    = list(string)
  default = []
}

variable "enable_terraform_apply" {
  type    = bool
  default = true
}

variable "enable_argocd_eks_policy" {
  type    = bool
  default = true
}

variable "eks_cluster_name" {
  type    = string
  default = ""
}

variable "allow_pull_request_oidc" {
  type = bool
}

variable "common_tags" {
  type = map(string)

  default = {
    Project     = "safespot"
    Environment = "dev"
    Domain      = "ops"
    ManagedBy   = "terraform"
    Service     = "safespot"
    CostCenter  = "safespot-dev"
  }
}