variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "ssm_parameters" {
  description = "SSM parameters to create"
  type = map(object({
    value       = string
    type        = optional(string, "String")
    description = optional(string)
  }))

  # sensitive = true
}

variable "remote_state_bucket" {
  description = "S3 bucket name for Terraform remote state."
  type        = string
  default     = "safespot-terraform-state"
}

variable "data_state_key" {
  description = "S3 object key for data Terraform state."
  type        = string
  default     = "environments/dev/data/terraform.tfstate"
}
