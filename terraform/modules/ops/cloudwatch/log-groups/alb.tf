# modules/ops/log-groups/alb.tf
#
# ALB access log 수집 방식:
#   방식 A (기본): ALB → S3 버킷 직접 저장
#   방식 B (선택): ALB → CloudWatch Logs (enable_alb_log_group = true)
#
# monitoring.md 섹션 1:
#   ALB/EKS metric → CloudWatch / Prometheus / Container Insights
#
# AWS ALB는 기본적으로 access log를 S3에 저장한다.
# CloudWatch Logs로 직접 전송하려면 별도 설정이 필요하다.
#
# TODO: ALB access log 수집 방식을 확정할 것.
#       방식 A (S3): network 파트에서 ALB 리소스에
#                   access_logs { bucket = var.alb_log_bucket_name, enabled = true } 설정
#       방식 B (CloudWatch): enable_alb_log_group = true 로 설정하고
#                            Kinesis Firehose 또는 Lambda를 통해 S3 → CloudWatch 연동
#
# 현재 기본값: enable_alb_log_group = false (방식 A, S3 저장)

# ── ALB Access Log용 CloudWatch Log Group (선택) ──────────────────────────────

resource "aws_cloudwatch_log_group" "alb_access_log" {
  count = var.enable_alb_log_group ? 1 : 0

  name              = local.alb_log_group_name
  retention_in_days = var.retention_days
  kms_key_id        = local.kms_key_arn

  tags = {
    Name      = local.alb_log_group_name
    LogType   = "alb-access-log"
    Component = "alb"
    # TODO: ALB access log를 CloudWatch Logs로 전송하는 방식을 확정 후
    #       Kinesis Firehose 또는 Lambda 연동 구성을 추가할 것.
    #       현재는 Log Group 리소스만 생성하고 전송 파이프라인은 미구현 상태.
    Purpose = "alb-access-log-cloudwatch"
  }
}

# ── ALB Access Log S3 버킷 정책 참고 ─────────────────────────────────────────
# 방식 A (S3) 사용 시 network 파트에 아래 내용이 필요하다.
# 이 모듈에서 직접 S3 버킷을 생성하지 않는다.
#
# TODO: network 파트에서 ALB access log S3 버킷을 생성할 때
#       아래 버킷 정책을 추가할 것.
#       ALB 서비스 계정 ID는 리전마다 다르므로 확인 필요.
#       서울(ap-northeast-2) ALB 계정 ID: 600734575887
#
# resource "aws_s3_bucket_policy" "alb_access_log" {
#   bucket = var.alb_log_bucket_name
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect    = "Allow"
#       Principal = { AWS = "arn:aws:iam::600734575887:root" }
#       Action    = "s3:PutObject"
#       Resource  = "arn:aws:s3:::${var.alb_log_bucket_name}/AWSLogs/*"
#     }]
#   })
# }