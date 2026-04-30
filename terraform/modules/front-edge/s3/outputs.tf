output "bucket_name" {
  description = "프론트엔드 S3 버킷 이름"
  value       = aws_s3_bucket.frontend.bucket
}

output "bucket_arn" {
  description = "프론트엔드 S3 버킷 ARN (CloudFront OAC 연결용)"
  value       = aws_s3_bucket.frontend.arn
}

output "bucket_regional_domain_name" {
  description = "CloudFront Origin 설정용 도메인"
  value       = aws_s3_bucket.frontend.bucket_regional_domain_name
}