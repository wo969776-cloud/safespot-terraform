# 프론트엔드 정적 파일용 S3 버킷
resource "aws_s3_bucket" "frontend" {
  bucket = "${var.project}-${var.environment}-frontend"

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-frontend"
  })
}

# 퍼블릭 액세스 완전 차단
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 버전 관리 활성화
resource "aws_s3_bucket_versioning" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  versioning_configuration {
    status = "Enabled"
  }
}