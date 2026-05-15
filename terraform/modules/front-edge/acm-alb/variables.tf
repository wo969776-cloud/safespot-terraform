variable "domain_name" {
  type    = string
  default = "safespot.site"
}

variable "route53_zone_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}