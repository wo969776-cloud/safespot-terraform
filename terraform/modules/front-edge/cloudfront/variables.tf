variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "domain_name" {
  description = "도메인 이름 (safespot.site)"
  type        = string
}

variable "bucket_name" {
  description = "프론트엔드 S3 버킷 이름"
  type        = string
}

variable "bucket_arn" {
  description = "프론트엔드 S3 버킷 ARN"
  type        = string
}

variable "bucket_regional_domain_name" {
  description = "S3 버킷 리전 도메인 (Origin 설정용)"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ACM 인증서 ARN (us-east-1)"
  type        = string
}

variable "waf_acl_arn" {
  description = "WAF ACL ARN (us-east-1)"
  type        = string
}

variable "api_origin_domain_name" {
  description = "CloudFront API origin 도메인 (api-origin.safespot.site)"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}
variable "route53_zone_id" {
  description = "Route53 Zone ID"
  type        = string
}
