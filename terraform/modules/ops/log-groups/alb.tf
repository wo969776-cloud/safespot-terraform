# ALB access log 수집 방식:
#   방식 A (기본): ALB → S3 버킷 직접 저장
#   방식 B (선택): ALB → CloudWatch Logs (enable_alb_log_group = true)
#
# [삭제] alb_log_bucket_name 변수 참조 제거

resource "aws_cloudwatch_log_group" "alb_access_log" {
  count = var.enable_alb_log_group ? 1 : 0

  name              = local.alb_log_group_name
  retention_in_days = var.retention_days
  kms_key_id        = local.kms_key_arn

  tags = {
    Name      = local.alb_log_group_name
    LogType   = "alb-access-log"
    Component = "alb"
    Purpose   = "alb-access-log-cloudwatch"
  }
}