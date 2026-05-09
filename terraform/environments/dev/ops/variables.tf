variable "aws_region" {
  type = string
}

variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "stg", "prod"], var.environment)
    error_message = "env는 dev, stg, prod 중 하나여야 합니다."
  }
}

variable "project" {
  type = string
}

variable "services" {
  description = "ECR 및 Log Group을 생성할 서비스 이름 목록"
  type        = list(string)
}

variable "log_retention_days" {
  description = "애플리케이션 CloudWatch Log Group 기본 보존 기간 (일)"
  type        = number
}

variable "remote_state_bucket" {
  description = "Terraform 원격 상태 S3 버킷 이름"
  type        = string
}

variable "remote_state_region" {
  description = "Terraform 원격 상태 S3 버킷 리전"
  type        = string
}

variable "alert_email" {
  type    = string
  default = ""
}

variable "slack_webhook_secret_name" {
  type    = string
  default = ""
}

variable "slack_webhook_url" {
  description = "AlertManager Slack Webhook URL. 비어 있으면 시크릿 이름만 생성하고 값은 콘솔/CLI에서 직접 입력."
  type        = string
  sensitive   = true
  default     = ""
}

variable "additional_email_subscriptions" {
  type    = list(string)
  default = []
}

variable "enable_slack_secret" {
  type    = bool
  default = true
}

variable "slack_webhook_recovery_window_days" {
  type    = number
  default = 7
}

variable "alb_5xx_elb_threshold" {
  description = "ALB 자체(ELB 레벨) 5xx 오류 수 임계값"
  type        = number
  default     = 0
}

variable "alb_5xx_threshold" {
  description = "ALB Target(서비스) 5xx 오류 수 임계값"
  type        = number
  default     = 0
}

variable "alb_4xx_threshold" {
  type    = number
  default = 100
}

variable "alb_latency_threshold_seconds" {
  description = "ALB TargetResponseTime 임계값 (초)"
  type        = number
  default     = 1
}


variable "nat_gateway_id" {
  description = "NAT Gateway ID. 비어 있으면 NAT GW 알람을 생성하지 않습니다."
  type        = string
  default     = ""
}

variable "natgw_packets_drop_threshold" {
  type    = number
  default = 0
}

variable "natgw_error_port_threshold" {
  type    = number
  default = 0
}

variable "sqs_in_flight_threshold" {
  description = "SQS in-flight 메시지 수 임계값"
  type        = number
  default     = 500
}

variable "cloudfront_cache_hit_rate_threshold" {
  description = "CloudFront 캐시 히트율 최소 임계값 (%)"
  type        = number
  default     = 70
}

variable "cloudfront_origin_latency_threshold_ms" {
  description = "CloudFront Origin 응답시간 임계값 (ms)"
  type        = number
  default     = 1000
}

variable "rds_cpu_threshold" {
  type    = number
  default = 80
}

variable "rds_connections_threshold" {
  type    = number
  default = 200
}

variable "rds_free_storage_threshold_bytes" {
  type    = number
  default = 10737418240
}

variable "redis_cpu_threshold" {
  type    = number
  default = 80
}

variable "redis_evictions_threshold" {
  type    = number
  default = 0
}

variable "redis_curr_connections_threshold" {
  type    = number
  default = 500
}

variable "redis_memory_threshold" {
  type    = number
  default = 80
}

variable "sqs_visible_threshold" {
  type    = number
  default = 100
}

variable "sqs_age_threshold_seconds" {
  type    = number
  default = 300
}

variable "dlq_visible_threshold" {
  type    = number
  default = 0
}

variable "dlq_age_threshold_seconds" {
  type    = number
  default = 3600
}

variable "lambda_error_threshold" {
  type    = number
  default = 0
}

variable "lambda_throttle_threshold" {
  type    = number
  default = 0
}

variable "lambda_duration_p99_threshold_ms" {
  type    = number
  default = 10000
}

variable "eks_pod_restart_threshold" {
  type    = number
  default = 3
}

variable "eks_node_cpu_threshold" {
  type    = number
  default = 80
}

variable "eks_node_memory_threshold" {
  type    = number
  default = 80
}

variable "image_tag_mutability" {
  type    = string
  default = "IMMUTABLE"
}

variable "scan_on_push" {
  type    = bool
  default = true
}

variable "max_image_count" {
  type    = number
  default = 20
}

variable "untagged_expiry_days" {
  type    = number
  default = 2
}

variable "lambda_retention_days" {
  type    = number
  default = 60
}

variable "eks_control_plane_retention_days" {
  type    = number
  default = 90
}

variable "eks_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "enable_alb_log_group" {
  type    = bool
  default = false
}

variable "kms_key_arn" {
  type    = string
  default = ""
}

variable "enable_observability_iam" {
  type    = bool
  default = false
}

variable "enable_grafana_irsa" {
  type    = bool
  default = false
}

variable "enable_prometheus_irsa" {
  type    = bool
  default = false
}

variable "enable_fluentbit_irsa" {
  type    = bool
  default = false
}

variable "enable_yace_irsa" {
  type    = bool
  default = false
}

variable "prometheus_k8s_namespace" {
  type    = string
  default = "monitoring"
}

variable "prometheus_service_account_name" {
  type    = string
  default = "prometheus"
}

variable "grafana_namespace" {
  type    = string
  default = "monitoring"
}

variable "grafana_service_account_name" {
  type    = string
  default = "safespot-grafana"
}

variable "fluentbit_namespace" {
  type    = string
  default = "logging"
}

variable "fluentbit_service_account_name" {
  type    = string
  default = "fluent-bit"
}

variable "yace_namespace" {
  type    = string
  default = "monitoring"
}

variable "yace_service_account_name" {
  type    = string
  default = "safespot-yace"
}

# ── log-bucket ────────────────────────────────────────────────

variable "log_bucket_force_destroy" {
  description = "로그 버킷 삭제 시 오브젝트 자동 제거 여부."
  type        = bool
  default     = false
}

variable "log_bucket_enable_versioning" {
  description = "로그 버킷 버전 관리 활성화 여부."
  type        = bool
  default     = false
}

variable "alb_log_retention_days" {
  description = "ALB 로그 보존 기간 (일)."
  type        = number
  default     = 90
}

variable "waf_log_retention_days" {
  description = "WAF 로그 보존 기간 (일)."
  type        = number
  default     = 90
}

variable "vpc_flow_log_retention_days" {
  description = "VPC Flow 로그 보존 기간 (일)."
  type        = number
  default     = 90
}

variable "rds_log_retention_days" {
  description = "RDS 로그 보존 기간 (일)."
  type        = number
  default     = 90
}

variable "cloudwatch_log_retention_days" {
  description = "CloudWatch 내보내기 로그 보존 기간 (일)."
  type        = number
  default     = 365
}

variable "cloudfront_distribution_id" {
  type    = string
  default = ""
}

variable "waf_acl_name" {
  description = "WAF Web ACL name. CloudWatch WAFV2 metric dimension WebACL에 사용"
  type        = string
  default     = ""
}

variable "rds_replica_lag_threshold_ms" {
  description = "Aurora 복제 지연 임계값(ms)"
  type        = number
  default     = 100
}

variable "rds_volume_bytes_threshold" {
  description = "Aurora VolumeBytesUsed 임계값(bytes)"
  type        = number
  default     = 100000000000
}

variable "redis_freeable_memory_threshold_bytes" {
  description = "ElastiCache FreeableMemory 최소 임계값(bytes)"
  type        = number
  default     = 100000000
}

variable "redis_bytes_used_threshold_bytes" {
  description = "ElastiCache BytesUsedForCache 최대 임계값(bytes)"
  type        = number
  default     = 3000000000
}
