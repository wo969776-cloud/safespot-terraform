variable "project" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "domain" {
  description = "Domain name."
  type        = string
}

variable "services" {
  description = "ECR Repository를 생성할 서비스 논리 이름 목록"
  type        = list(string)

  default = [
    "api-core",
    "api-public-read",
    "external-ingestion",
  ]
}

variable "image_tag_mutability" {
  type    = string
  default = "IMMUTABLE"

  validation {
    condition     = contains(["IMMUTABLE", "MUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability는 IMMUTABLE 또는 MUTABLE이어야 합니다."
  }
}

variable "scan_on_push" {
  type    = bool
  default = true
}

variable "encrypt_type" {
  type    = string
  default = "AES256"
}

variable "kms_key_arn" {
  type    = string
  default = ""
}

variable "max_image_count" {
  type    = number
  default = 20
}

variable "untagged_expiry_days" {
  type    = number
  default = 2
}
