locals {
  domain = "proactive-scale"

  common_tags = {
    Project     = var.project
    Environment = var.environment
    Domain      = local.domain
    ManagedBy   = "terraform"
    Service     = var.project
    CostCenter  = "${var.project}-${var.environment}"
  }
}
