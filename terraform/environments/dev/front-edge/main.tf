# data "terraform_remote_state" "api_service" {
#   backend = "s3"
#   config = {
#     bucket = "safespot-terraform-state"
#     key    = "environments/dev/api-service/terraform.tfstate"
#     region = "ap-northeast-2" 
#   }
# }

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

module "acm_alb" {
  source = "../../../modules/front-edge/acm-alb"

  domain_name     = var.domain_name
  route53_zone_id = module.route53.zone_id
  tags            = local.common_tags
}

module "waf" {
  source = "../../../modules/front-edge/waf"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags
}

module "s3" {
  source = "../../../modules/front-edge/s3"

  project     = var.project
  environment = var.environment
  common_tags = local.common_tags
}

module "cloudfront" {
  source = "../../../modules/front-edge/cloudfront"

  project     = var.project
  environment = var.environment
  domain_name = var.domain_name

  bucket_name                 = module.s3.bucket_name
  bucket_arn                  = module.s3.bucket_arn
  bucket_regional_domain_name = module.s3.bucket_regional_domain_name

  acm_certificate_arn = module.acm.certificate_arn
  waf_acl_arn         = module.waf.waf_acl_arn

  api_origin_domain_name = "api-origin.safespot.site"
  route53_zone_id        = module.route53.zone_id

  cloudfront_log_bucket_domain_name = "safespot-dev-ops-logs.s3.amazonaws.com"
  cloudfront_log_prefix             = "cloudfront/"

  common_tags = local.common_tags
}

