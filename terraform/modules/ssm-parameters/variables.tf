variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "parameters" {
  type = map(object({
    value       = string
    type        = string
    description = optional(string)
  }))

  validation {
    condition = alltrue([
      for p in values(var.parameters) : contains(["String", "StringList", "SecureString"], p.type)
    ])
    error_message = "parameter type must be String, StringList, or SecureString."
  }
}

variable "use_custom_kms_key" {
  type    = bool
  default = false
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

