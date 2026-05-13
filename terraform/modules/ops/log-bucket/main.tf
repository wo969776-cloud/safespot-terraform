data "aws_region" "current" {}

# ── S3 버킷 ──────────────────────────────────────────────────

resource "aws_s3_bucket" "log" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy
  tags          = local.tags
}

resource "aws_s3_bucket_ownership_controls" "log" {
  bucket = aws_s3_bucket.log.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "log" {
  bucket = aws_s3_bucket.log.id
  acl    = "private"

  depends_on = [
    aws_s3_bucket_ownership_controls.log
  ]
}


resource "aws_s3_bucket_public_access_block" "log" {
  bucket                  = aws_s3_bucket.log.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "log" {
  bucket = aws_s3_bucket.log.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log" {
  bucket = aws_s3_bucket.log.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_arn != "" ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_arn != "" ? var.kms_key_arn : null
    }
    bucket_key_enabled = var.kms_key_arn != "" ? true : false
  }
}

# ── 라이프사이클 ──────────────────────────────────────────────

resource "aws_s3_bucket_lifecycle_configuration" "log" {
  bucket = aws_s3_bucket.log.id

  rule {
    id     = "alb-expiry"
    status = "Enabled"
    filter { prefix = "${local.prefixes.alb}/" }
    expiration { days = var.alb_retention_days }
  }

  rule {
    id     = "waf-expiry"
    status = "Enabled"
    filter { prefix = "${local.prefixes.waf}/" }
    expiration { days = var.waf_retention_days }
  }

  rule {
    id     = "vpc-flow-expiry"
    status = "Enabled"
    filter { prefix = "${local.prefixes.vpc_flow}/" }
    expiration { days = var.vpc_flow_retention_days }
  }

  rule {
    id     = "rds-expiry"
    status = "Enabled"
    filter { prefix = "${local.prefixes.rds}/" }
    expiration { days = var.rds_retention_days }
  }

  rule {
    id     = "cloudwatch-expiry"
    status = "Enabled"
    filter { prefix = "${local.prefixes.cloudwatch}/" }
    expiration { days = var.cloudwatch_retention_days }
  }

    rule {
    id     = "cloudfront-expiry"
    status = "Enabled"

    filter {
      prefix = "${local.prefixes.cloudfront}/"
    }

    expiration {
      days = var.cloudfront_retention_days
    }
  }
}

# ── 버킷 정책 ─────────────────────────────────────────────────

resource "aws_s3_bucket_policy" "log" {
  bucket = aws_s3_bucket.log.id
  policy = data.aws_iam_policy_document.log.json

  depends_on = [aws_s3_bucket_public_access_block.log]
}

data "aws_iam_policy_document" "log" {
  # ALB 접근 로그
  # 신규 리전(2022-08 이후)은 서비스 주체 + SourceAccount 방식 사용
  statement {
    sid    = "AllowALBLogs"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.log.arn}/${local.prefixes.alb}/AWSLogs/${var.aws_account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.aws_account_id]
    }
  }

  # WAF 로그 (Kinesis Firehose delivery.logs → S3)
  statement {
    sid    = "AllowWAFLogs"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.log.arn}/${local.prefixes.waf}/AWSLogs/${var.aws_account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.aws_account_id]
    }
  }

    # CloudFront 접근 로그
  statement {
    sid    = "AllowCloudFrontLogs"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.log.arn}/${local.prefixes.cloudfront}/AWSLogs/${var.aws_account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.aws_account_id]
    }
  }

  # VPC Flow 로그
  statement {
    sid    = "AllowVPCFlowLogs"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = ["s3:PutObject"]
    resources = [
      "${aws_s3_bucket.log.arn}/${local.prefixes.vpc_flow}/AWSLogs/${var.aws_account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.aws_account_id]
    }
  }

  # VPC Flow 로그 ACL 확인 허용
  statement {
    sid    = "AllowVPCFlowLogsAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.log.arn]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.aws_account_id]
    }
  }

  # RDS 로그 (CloudWatch → S3 export task 또는 직접 적재 시 계정 내 서비스 허용)
  statement {
    sid    = "AllowRDSLogs"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }

    actions = ["s3:PutObject", "s3:GetBucketAcl"]
    resources = [
      "${aws_s3_bucket.log.arn}/${local.prefixes.rds}/*",
      aws_s3_bucket.log.arn,
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.aws_account_id]
    }
  }

  # CloudWatch Logs export task
  statement {
    sid    = "AllowCloudWatchLogsExport"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }

    actions = ["s3:PutObject", "s3:GetBucketAcl"]
    resources = [
      "${aws_s3_bucket.log.arn}/${local.prefixes.cloudwatch}/*",
      aws_s3_bucket.log.arn,
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.aws_account_id]
    }
  }

  # SSL-only 강제
  statement {
    sid    = "DenyNonSSL"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["s3:*"]
    resources = [aws_s3_bucket.log.arn, "${aws_s3_bucket.log.arn}/*"]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
