variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "project" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "terraform_state_bucket" {
  description = "S3 bucket that stores Terraform remote state."
  type        = string
}

variable "common_tags" {
  description = "Common tags for resources."
  type        = map(string)
  default     = {}
}
