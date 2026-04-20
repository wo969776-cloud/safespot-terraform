output "zone_id" {
  description = "Route53 Hosted Zone ID"
  value       = aws_route53_zone.main.zone_id
}

output "zone_name" {
  description = "Route53 Hosted Zone Name"
  value       = aws_route53_zone.main.name
}

output "name_servers" {
  description = "Route53 Name Servers (가비아 네임서버 변경 시 사용)"
  value       = aws_route53_zone.main.name_servers
}