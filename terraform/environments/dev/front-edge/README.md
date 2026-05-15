# front-edge

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | ../../../modules/front-edge/acm | n/a |
| <a name="module_acm_alb"></a> [acm\_alb](#module\_acm\_alb) | ../../../modules/front-edge/acm-alb | n/a |
| <a name="module_cloudfront"></a> [cloudfront](#module\_cloudfront) | ../../../modules/front-edge/cloudfront | n/a |
| <a name="module_route53"></a> [route53](#module\_route53) | ../../../modules/front-edge/route53 | n/a |
| <a name="module_s3"></a> [s3](#module\_s3) | ../../../modules/front-edge/s3 | n/a |
| <a name="module_waf"></a> [waf](#module\_waf) | ../../../modules/front-edge/waf | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_certificate_arn"></a> [alb\_certificate\_arn](#output\_alb\_certificate\_arn) | ALB HTTPS 리스너 연결용 인증서 ARN (ap-northeast-2) |
| <a name="output_api_origin_domain_name"></a> [api\_origin\_domain\_name](#output\_api\_origin\_domain\_name) | API origin 도메인 (api-service/k8s-manifest 참조용) |
| <a name="output_certificate_arn"></a> [certificate\_arn](#output\_certificate\_arn) | CloudFront HTTPS 연결용 인증서 ARN (us-east-1) |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | CloudFront Distribution ID |
| <a name="output_cloudfront_domain_name"></a> [cloudfront\_domain\_name](#output\_cloudfront\_domain\_name) | CloudFront Distribution 도메인 (Route53 A 레코드 연결용) |
| <a name="output_frontend_bucket_arn"></a> [frontend\_bucket\_arn](#output\_frontend\_bucket\_arn) | CloudFront OAC 연결용 버킷 ARN |
| <a name="output_frontend_bucket_domain"></a> [frontend\_bucket\_domain](#output\_frontend\_bucket\_domain) | CloudFront Origin 설정용 도메인 |
| <a name="output_frontend_bucket_name"></a> [frontend\_bucket\_name](#output\_frontend\_bucket\_name) | 프론트엔드 S3 버킷 이름 |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | 가비아 네임서버 변경 시 사용 |
| <a name="output_route53_zone_id"></a> [route53\_zone\_id](#output\_route53\_zone\_id) | n/a |
| <a name="output_route53_zone_name"></a> [route53\_zone\_name](#output\_route53\_zone\_name) | n/a |
| <a name="output_waf_acl_arn"></a> [waf\_acl\_arn](#output\_waf\_acl\_arn) | WAF ACL ARN (ops 파트 CloudWatch 알람 타겟용) |
| <a name="output_waf_acl_name"></a> [waf\_acl\_name](#output\_waf\_acl\_name) | WAF ACL name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
