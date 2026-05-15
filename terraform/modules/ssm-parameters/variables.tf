variable "parameters" {
  description = "Non-sensitive SSM String parameters."

  type = map(object({
    name        = string
    value       = string
    description = optional(string)
  }))
}
