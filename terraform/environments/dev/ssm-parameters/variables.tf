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

variable "alb_arn_suffix" {
  description = "ALB ARN suffix for CloudWatch metrics (e.g. app/safespot-dev-alb/<id>). Set after AWS Load Balancer Controller creates the ALB."
  type        = string
  default     = ""
}

variable "api_target_group_arn_suffix" {
  description = "API TargetGroup ARN suffix for CloudWatch metrics (e.g. targetgroup/<tg-name>/<id>). Set after the target group is created."
  type        = string
  default     = ""
}
