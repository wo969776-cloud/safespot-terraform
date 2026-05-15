resource "aws_ecr_repository" "services" {
  for_each = toset(var.services)

  name                 = "${var.project}-${var.environment}-${var.domain}-ecr-${each.key}"
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encrypt_type
    kms_key         = var.encrypt_type == "KMS" ? var.kms_key_arn : null
  }

  force_delete = var.environment != "prod"

  tags = {
    Name        = "${var.project}-${var.environment}-${var.domain}-ecr-${each.key}"
    Project     = var.project
    Environment = var.environment
    Domain      = var.domain
    ManagedBy   = "terraform"
    Service     = each.key
    CostCenter  = "${var.project}-${var.environment}"
  }
}
