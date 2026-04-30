resource "aws_ssm_parameter" "this" {
  for_each = var.parameters

  name        = "/${var.project}/${var.env}/${each.key}"
  type        = each.value.type
  value       = each.value.value
  description = try(each.value.description, null)

  key_id = each.value.type == "SecureString" && var.use_custom_kms_key ? var.kms_key_id : null

  overwrite = true

  tags = var.common_tags
}
