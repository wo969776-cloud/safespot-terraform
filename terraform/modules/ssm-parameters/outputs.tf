output "parameter_names" {
  description = "Created SSM parameter names."

  value = {
    for k, v in aws_ssm_parameter.this : k => v.name
  }
}

output "parameter_arns" {
  description = "Created SSM parameter ARNs."

  value = {
    for k, v in aws_ssm_parameter.this : k => v.arn
  }
}
