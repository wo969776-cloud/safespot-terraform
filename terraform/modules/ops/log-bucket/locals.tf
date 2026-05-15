locals {
  domain      = "ops"
  name_prefix = "${var.project}-${var.environment}-${local.domain}"
  bucket_name = "${local.name_prefix}-logs"

  tags = merge(var.tags, {
    Project     = var.project
    Environment = var.environment
    Domain      = local.domain
    ManagedBy   = "terraform"
  })

  prefixes = {
    alb        = "alb"
    waf        = "waf"
    vpc_flow   = "vpc-flow"
    rds        = "rds"
    cloudwatch = "cloudwatch"
    cloudfront = "cloudfront"
  }
}
