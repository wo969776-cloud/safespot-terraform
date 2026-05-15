output "waf_acl_arn" {
  value       = aws_wafv2_web_acl.main.arn
  description = "CloudFront 연결용 WAF ACL ARN" # 
}

output "waf_acl_id" {
  value       = aws_wafv2_web_acl.main.id
  description = "WAF ACL ID"
}
output "acl_name" {
  value       = aws_wafv2_web_acl.main.name
  description = "WAF ACL name"
}
