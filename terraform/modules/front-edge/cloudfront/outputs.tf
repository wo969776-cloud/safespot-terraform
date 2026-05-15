output "distribution_id" {
  description = "CloudFront Distribution ID"
  value       = aws_cloudfront_distribution.main.id
}

output "distribution_arn" {
  description = "CloudFront Distribution ARN"
  value       = aws_cloudfront_distribution.main.arn
}

output "distribution_domain_name" {
  description = "CloudFront Distribution 도메인 (Route53 A 레코드 연결용)"
  value       = aws_cloudfront_distribution.main.domain_name
}

output "api_origin_domain_name" {
  description = "API origin 도메인 (api-service/k8s-manifest 참조용)"
  value       = var.api_origin_domain_name
}