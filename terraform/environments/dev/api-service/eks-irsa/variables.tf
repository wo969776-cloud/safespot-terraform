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
  description = "S3 object key for eks-core Terraform state."
  type        = string
  default     = "environments/dev/api-service/eks-core/terraform.tfstate"
}

variable "async_worker_state_key" {
  description = "S3 object key for async-worker Terraform state."
  type        = string
  default     = "environments/dev/async-worker/terraform.tfstate"
}

variable "alb_controller_namespace" {
  description = "Kubernetes namespace for AWS Load Balancer Controller."
  type        = string
  default     = "kube-system"
}

variable "alb_controller_service_account_name" {
  description = "Kubernetes ServiceAccount name for AWS Load Balancer Controller."
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "app_namespace" {
  description = "Kubernetes namespace for application pods."
  type        = string
  default     = "application"
}

variable "api_core_service_account_name" {
  description = "Kubernetes ServiceAccount name for api-core."
  type        = string
  default     = "api-core"
}

variable "api_public_read_service_account_name" {
  description = "Kubernetes ServiceAccount name for api-public-read."
  type        = string
  default     = "api-public-read"
}

variable "external_ingestion_service_account_name" {
  description = "Kubernetes ServiceAccount name for external-ingestion."
  type        = string
  default     = "external-ingestion"
}

variable "pre_scaling_controller_service_account_name" {
  description = "Kubernetes ServiceAccount name for pre-scaling-controller."
  type        = string
  default     = "pre-scaling-controller"
}
