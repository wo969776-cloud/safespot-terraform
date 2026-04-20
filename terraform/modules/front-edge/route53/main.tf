resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-front-edge-route53-main"
  })
}