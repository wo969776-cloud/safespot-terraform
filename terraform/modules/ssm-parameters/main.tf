resource "aws_ssm_parameter" "this" {
  for_each = var.parameters

  name        = each.value.name
  description = try(each.value.description, null)
  type        = "String"
  value       = each.value.value
  overwrite   = true
}
