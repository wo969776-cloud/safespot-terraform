output "certificate_arn" {
  value       = aws_acm_certificate_validation.main.certificate_arn
  description = "ALB HTTPS 리스너 연결용 인증서 ARN (ap-northeast-2)"
}