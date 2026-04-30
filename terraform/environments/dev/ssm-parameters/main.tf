module "ssm_parameters" {
  source = "../../../modules/ssm-parameters"

  project = var.project
  env     = var.env

  parameters = {
    for key, param in var.ssm_parameters : key => {
      name        = "/safespot/${var.env}/${key}"
      value       = param.value
      type        = lookup(param, "type", "String")
      description = lookup(param, "description", "")
    }
  }

  use_custom_kms_key = false
  kms_key_id         = null

  common_tags = local.common_tags
}
