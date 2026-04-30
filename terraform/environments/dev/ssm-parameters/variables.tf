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
  type = map(object({
    value       = string
    type        = string
    description = optional(string)
  }))
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
