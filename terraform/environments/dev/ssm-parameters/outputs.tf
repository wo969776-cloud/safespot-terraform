output "parameter_names" {
  value = module.ssm_parameters.parameter_names
}

output "parameter_arns" {
  value = module.ssm_parameters.parameter_arns
}

output "secure_parameter_names" {
  value = module.ssm_parameters.secure_parameter_names
}

output "string_parameter_names" {
  value = module.ssm_parameters.string_parameter_names
}
