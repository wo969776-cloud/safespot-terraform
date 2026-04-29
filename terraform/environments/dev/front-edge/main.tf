module "route53" {
  source = "../../../modules/front-edge/route53"

  project     = var.project
  environment = var.environment
  domain_name = var.domain_name

  common_tags = local.common_tags
}

module "acm" {
  source = "../../../modules/front-edge/acm"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  domain_name     = var.domain_name
  route53_zone_id = module.route53.zone_id
  tags            = local.common_tags
}

# module "waf" {
#   source = "../../../modules/front-edge/waf"

#   providers = {
#     aws.us_east_1 = aws.us_east_1 
#   }

#   project     = var.project
#   environment = var.environment
#   common_tags = local.common_tags
# }