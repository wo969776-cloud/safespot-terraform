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

  sensitive = true
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
