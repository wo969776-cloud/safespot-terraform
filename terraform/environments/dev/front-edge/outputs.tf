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