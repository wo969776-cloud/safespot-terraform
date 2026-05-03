module "ssm_parameters" {
  source = "../../../modules/ssm-parameters"

  project = var.project
  env     = var.env

  parameters = merge(
    var.ssm_parameters,
    local.remote_state_parameters
  )

  use_custom_kms_key = false
  kms_key_id         = null

  common_tags = local.common_tags
}
