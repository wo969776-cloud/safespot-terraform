variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "remote_state_bucket" {
  description = "S3 bucket name for Terraform remote state"
  type        = string
  default     = "safespot-terraform-state"
}

variable "eks_core_state_key" {
  description = "S3 object key for EKS core Terraform state"
  type        = string
}

variable "external_dns_namespace" {
  description = "Kubernetes namespace for ExternalDNS"
  type        = string
  default     = "external-dns"
}

variable "external_dns_service_account_name" {
  description = "Kubernetes service account name for ExternalDNS"
  type        = string
  default     = "external-dns"
}

variable "external_dns_zone_name" {
  description = "Route53 public hosted zone name managed by ExternalDNS"
  type        = string
  default     = "safespot.site"
}

variable "external_secrets_namespace" {
  description = "Kubernetes namespace for External Secrets Operator"
  type        = string
  default     = "external-secrets"
}

variable "external_secrets_service_account_name" {
  description = "Kubernetes service account name for External Secrets Operator"
  type        = string
  default     = "external-secrets"
}

variable "ebs_csi_namespace" {
  description = "Kubernetes namespace for AWS EBS CSI Driver"
  type        = string
  default     = "kube-system"
}

variable "ebs_csi_service_account_name" {
  description = "Kubernetes service account name for AWS EBS CSI Driver controller"
  type        = string
  default     = "ebs-csi-controller-sa"
}
