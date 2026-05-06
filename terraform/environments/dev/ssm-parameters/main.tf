module "ssm_parameters" {
  source = "../../../modules/ssm-parameters"

  parameters = local.string_parameters
}
