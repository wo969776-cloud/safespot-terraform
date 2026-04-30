# CloudFront OAC (S3 접근용)
resource "aws_cloudfront_origin_access_control" "frontend" {
  name                              = "${var.project}-${var.environment}-frontend-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# S3 버킷 정책 (CloudFront OAC만 허용)
resource "aws_s3_bucket_policy" "frontend" {
  bucket = var.bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${var.bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.main.arn
          }
        }
      }
    ]
  })
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "main" {
  enabled             = true
  comment             = "${var.project}-${var.environment} CloudFront Distribution"
  default_root_object = "index.html"
  aliases             = [var.domain_name]
  web_acl_id          = var.waf_acl_arn
  price_class         = "PriceClass_200"

  # Origin 1 — S3 (정적 파일)
  origin {
    origin_id                = "S3-frontend"
    domain_name              = var.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.frontend.id
  }

  # Origin 2 — ALB (API)
  origin {
    origin_id   = "ALB-api"
    domain_name = var.alb_dns_name

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # Behavior 1 — 인증 API (캐싱 금지)
  ordered_cache_behavior {
    path_pattern             = "/api/auth/*"
    target_origin_id         = "ALB-api"
    viewer_protocol_policy   = "redirect-to-https"
    allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods           = ["GET", "HEAD"]
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # CachingDisabled
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3" # AllViewer
  }

  # Behavior 2 — 관리자 API (캐싱 금지)
  ordered_cache_behavior {
    path_pattern             = "/api/admin/*"
    target_origin_id         = "ALB-api"
    viewer_protocol_policy   = "redirect-to-https"
    allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods           = ["GET", "HEAD"]
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # CachingDisabled
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3" # AllViewer
  }

  # Behavior 3 — 사용자 정보 API (캐싱 금지)
  ordered_cache_behavior {
    path_pattern             = "/api/me"
    target_origin_id         = "ALB-api"
    viewer_protocol_policy   = "redirect-to-https"
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # CachingDisabled
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3" # AllViewer
  }

  # Behavior 4 — 대피소 조회 API (TTL 30초 — 재난시에도 유지)
  ordered_cache_behavior {
    path_pattern           = "/api/shelters/*"
    target_origin_id       = "ALB-api"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = aws_cloudfront_cache_policy.shelters.id
  }

  # Behavior 5 — 재난 정보 API (평상시 TTL 60초)
  ordered_cache_behavior {
    path_pattern           = "/api/disaster-alerts"
    target_origin_id       = "ALB-api"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = aws_cloudfront_cache_policy.disaster.id
  }

  # Behavior 6 — 날씨 API (TTL 3600초)
  ordered_cache_behavior {
    path_pattern           = "/api/weather-alerts"
    target_origin_id       = "ALB-api"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = aws_cloudfront_cache_policy.weather.id
  }

  # Behavior 7 — 대기질 API (TTL 3600초)
  ordered_cache_behavior {
    path_pattern           = "/api/air-quality"
    target_origin_id       = "ALB-api"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = aws_cloudfront_cache_policy.air.id
  }

  # Default Behavior — S3 정적 파일
  default_cache_behavior {
    target_origin_id       = "S3-frontend"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" # CachingOptimized
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-front-edge-cloudfront"
  })
}

# Cache Policy — 대피소 (TTL 30초 — 재난시에도 유지)
resource "aws_cloudfront_cache_policy" "shelters" {
  name        = "${var.project}-${var.environment}-shelters"
  default_ttl = 30
  min_ttl     = 0
  max_ttl     = 60

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config { cookie_behavior = "none" }
    headers_config { header_behavior = "none" }
    query_strings_config {
      query_string_behavior = "all"
    }
    enable_accept_encoding_gzip   = true
    enable_accept_encoding_brotli = true
  }
}

# Cache Policy — 재난 (평상시 TTL 60초)
resource "aws_cloudfront_cache_policy" "disaster" {
  name        = "${var.project}-${var.environment}-disaster"
  default_ttl = 60
  min_ttl     = 0
  max_ttl     = 120

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config { cookie_behavior = "none" }
    headers_config { header_behavior = "none" }
    query_strings_config {
      query_string_behavior = "all"
    }
    enable_accept_encoding_gzip   = true
    enable_accept_encoding_brotli = true
  }
}

# Cache Policy — 날씨 (TTL 3600초)
resource "aws_cloudfront_cache_policy" "weather" {
  name        = "${var.project}-${var.environment}-weather"
  default_ttl = 3600
  min_ttl     = 60
  max_ttl     = 7200

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config { cookie_behavior = "none" }
    headers_config { header_behavior = "none" }
    query_strings_config {
      query_string_behavior = "all"
    }
    enable_accept_encoding_gzip   = true
    enable_accept_encoding_brotli = true
  }
}

# Cache Policy — 대기질 (TTL 3600초)
resource "aws_cloudfront_cache_policy" "air" {
  name        = "${var.project}-${var.environment}-air"
  default_ttl = 3600
  min_ttl     = 60
  max_ttl     = 7200

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config { cookie_behavior = "none" }
    headers_config { header_behavior = "none" }
    query_strings_config {
      query_string_behavior = "all"
    }
    enable_accept_encoding_gzip   = true
    enable_accept_encoding_brotli = true
  }
}