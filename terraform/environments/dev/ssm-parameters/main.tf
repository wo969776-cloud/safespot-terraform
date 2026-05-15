module "ssm_parameters" {
  source = "../../../modules/ssm-parameters"

  parameters = merge(local.string_parameters, local.optional_string_parameters)
}
