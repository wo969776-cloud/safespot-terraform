output "bucket_id" {
  description = "S3 로그 버킷 ID (이름)."
  value       = aws_s3_bucket.log.id
}

output "bucket_arn" {
  description = "S3 로그 버킷 ARN."
  value       = aws_s3_bucket.log.arn
}

output "bucket_domain_name" {
  description = "S3 버킷 도메인 이름."
  value       = aws_s3_bucket.log.bucket_domain_name
}

output "prefixes" {
  description = "각 서비스별 S3 prefix 맵."
  value       = local.prefixes
}

output "alb_log_prefix" {
  description = "ALB 접근 로그 prefix. ALB 로깅 설정에 직접 사용."
  value       = "${local.prefixes.alb}/AWSLogs/${var.aws_account_id}"
}

output "waf_log_prefix" {
  description = "WAF 로그 prefix."
  value       = "${local.prefixes.waf}/AWSLogs/${var.aws_account_id}"
}

output "vpc_flow_log_prefix" {
  description = "VPC Flow 로그 prefix."
  value       = "${local.prefixes.vpc_flow}/AWSLogs/${var.aws_account_id}"
}

output "rds_log_prefix" {
  description = "RDS 로그 prefix."
  value       = local.prefixes.rds
}

output "cloudwatch_export_prefix" {
  description = "CloudWatch Logs export task에 사용할 prefix."
  value       = local.prefixes.cloudwatch
}

output "cloudfront_log_prefix" {
  description = "CloudFront 접근 로그 prefix."
  value       = "${local.prefixes.cloudfront}/AWSLogs/${var.aws_account_id}"
}