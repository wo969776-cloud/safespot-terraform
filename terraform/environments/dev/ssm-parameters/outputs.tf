output "parameter_names" {
  description = "Created non-sensitive SSM String parameter names."

  value = module.ssm_parameters.parameter_names
}

output "parameter_arns" {
  description = "Created non-sensitive SSM String parameter ARNs."

  value = module.ssm_parameters.parameter_arns
}

output "secure_parameter_paths" {
  description = "SecureString parameter path contract. Values are managed outside Terraform."

  value = local.secure_parameter_paths
}
