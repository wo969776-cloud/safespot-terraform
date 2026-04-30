locals {
  domain = "ssm-parameters"

  common_tags = {
    Project     = var.project
    Environment = var.env
    Domain      = local.domain
    ManagedBy   = "terraform"
    Service     = var.project
    CostCenter  = "${var.project}-${var.env}"
  }
}
