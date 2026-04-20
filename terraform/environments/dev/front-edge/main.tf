module "route53" {
  source = "../../../modules/front-edge/route53"

  project     = var.project
  environment = var.environment
  domain_name = var.domain_name

  common_tags = local.common_tags
}