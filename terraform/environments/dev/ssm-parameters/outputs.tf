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

output "api_core_irsa_role_arn_ssm_parameter_name" {
  description = "SSM parameter name for api-core IRSA role ARN."
  value       = local.string_parameters.api_core_irsa_role_arn.name
}

output "api_public_read_irsa_role_arn_ssm_parameter_name" {
  description = "SSM parameter name for api-public-read IRSA role ARN."
  value       = local.string_parameters.api_public_read_irsa_role_arn.name
}

output "external_ingestion_irsa_role_arn_ssm_parameter_name" {
  description = "SSM parameter name for external-ingestion IRSA role ARN."
  value       = local.string_parameters.external_ingestion_irsa_role_arn.name
}

output "pre_scaling_controller_irsa_role_arn_ssm_parameter_name" {
  description = "SSM parameter name for pre-scaling-controller IRSA role ARN."
  value       = local.string_parameters.pre_scaling_controller_irsa_role_arn.name
}
