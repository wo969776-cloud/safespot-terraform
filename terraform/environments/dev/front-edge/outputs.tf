output "route53_zone_id" {
  value = module.route53.zone_id
}

output "route53_zone_name" {
  value = module.route53.zone_name
}

output "name_servers" {
  description = "가비아 네임서버 변경 시 사용"
  value       = module.route53.name_servers
}

output "certificate_arn" {
  description = "CloudFront / ALB HTTPS 리스너 연결용 인증서 ARN"
  value       = module.acm.certificate_arn
}

output "frontend_bucket_name" {
  description = "프론트엔드 S3 버킷 이름"
  value       = module.s3.bucket_name
}

output "frontend_bucket_arn" {
  description = "CloudFront OAC 연결용 버킷 ARN"
  value       = module.s3.bucket_arn
}

output "frontend_bucket_domain" {
  description = "CloudFront Origin 설정용 도메인"
  value       = module.s3.bucket_regional_domain_name
}

# output "cloudfront_distribution_id" {
#   description = "CloudFront Distribution ID"
#   value       = module.cloudfront.distribution_id
# }
#
# output "cloudfront_domain_name" {
#   description = "CloudFront Distribution 도메인 (Route53 A 레코드 연결용)"
#   value       = module.cloudfront.distribution_domain_name
# }