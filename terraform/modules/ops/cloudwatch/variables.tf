variable "project" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "sns_topic_arn" {
  type = string
}

variable "edge_sns_topic_arn" {
  description = "CloudFront/WAF global metric alarm action SNS Topic ARN. us-east-1 topic이어야 합니다."
  type        = string
}


variable "alb_arn_suffix" {
  description = "ALB ARN suffix. 형식: app/{alb-name}/{id}."
  type        = string

  validation {
    condition     = length(trimspace(var.alb_arn_suffix)) > 0
    error_message = "alb_arn_suffix는 반드시 설정해야 합니다."
  }
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

variable "alb_latency_threshold" {
  description = "ALB TargetResponseTime 임계값 (초)"
  type        = number
  default     = 1
}

variable "rds_cluster_identifier" {
  description = "Aurora DB 클러스터 식별자"
  type        = string

  validation {
    condition     = length(trimspace(var.rds_cluster_identifier)) > 0
    error_message = "rds_cluster_identifier는 반드시 설정해야 합니다."
  }
}

variable "rds_cpu_threshold" {
  type    = number
  default = 80
}

variable "rds_connections_threshold" {
  type    = number
  default = 200
}

variable "rds_read_latency_threshold" {
  type    = number
  default = 0.1
}

variable "rds_write_latency_threshold" {
  type    = number
  default = 0.1
}

variable "rds_deadlock_threshold" {
  type    = number
  default = 0
}

variable "rds_free_storage_threshold_bytes" {
  type    = number
  default = 10737418240
}

variable "redis_cluster_id" {
  description = "ElastiCache 복제 그룹 ID"
  type        = string

  validation {
    condition     = length(trimspace(var.redis_cluster_id)) > 0
    error_message = "redis_cluster_id는 반드시 설정해야 합니다."
  }
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

variable "sqs_queue_names" {
  description = "SQS 큐 이름 맵. 모든 필드 필수."
  type = object({
    cache_refresh = string
    readmodel     = string
    env_cache     = string
    dlq           = string
  })

  validation {
    condition     = length(trimspace(var.sqs_queue_names.cache_refresh)) > 0
    error_message = "sqs_queue_names.cache_refresh는 반드시 설정해야 합니다."
  }

  validation {
    condition     = length(trimspace(var.sqs_queue_names.readmodel)) > 0
    error_message = "sqs_queue_names.readmodel는 반드시 설정해야 합니다."
  }

  validation {
    condition     = length(trimspace(var.sqs_queue_names.env_cache)) > 0
    error_message = "sqs_queue_names.env_cache는 반드시 설정해야 합니다."
  }

  validation {
    condition     = length(trimspace(var.sqs_queue_names.dlq)) > 0
    error_message = "sqs_queue_names.dlq는 반드시 설정해야 합니다."
  }
}

variable "sqs_visible_threshold" {
  description = "SQS 대기 메시지 수 임계값"
  type        = number
  default     = 1000
}

variable "sqs_age_threshold_seconds" {
  type    = number
  default = 300
}

variable "sqs_in_flight_threshold" {
  description = "SQS in-flight(처리 중) 메시지 수 임계값. 급증 감지용."
  type        = number
  default     = 500
}

variable "dlq_visible_threshold" {
  type    = number
  default = 0
}

variable "dlq_age_threshold_seconds" {
  type    = number
  default = 3600
}

variable "lambda_function_name" {
  description = "Lambda 함수 이름"
  type        = string

  validation {
    condition     = length(trimspace(var.lambda_function_name)) > 0
    error_message = "lambda_function_name는 반드시 설정해야 합니다."
  }
}

variable "lambda_error_threshold" {
  type    = number
  default = 0
}

variable "lambda_throttle_threshold" {
  type    = number
  default = 0
}

variable "lambda_duration_threshold_ms" {
  type    = number
  default = 10000
}

variable "lambda_concurrent_executions_threshold" {
  type    = number
  default = 80
}

variable "eks_cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string

  validation {
    condition     = length(trimspace(var.eks_cluster_name)) > 0
    error_message = "eks_cluster_name는 반드시 설정해야 합니다."
  }
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

variable "cloudfront_distribution_id" {
  description = "CloudFront 배포 ID"
  type        = string

  validation {
    condition     = length(trimspace(var.cloudfront_distribution_id)) > 0
    error_message = "cloudfront_distribution_id는 반드시 설정해야 합니다."
  }
}

variable "waf_acl_name" {
  description = "WAF Web ACL 이름"
  type        = string

  validation {
    condition     = length(trimspace(var.waf_acl_name)) > 0
    error_message = "waf_acl_name는 반드시 설정해야 합니다."
  }
}

variable "cloudfront_5xx_threshold" {
  type    = number
  default = 1
}

variable "cloudfront_4xx_threshold" {
  type    = number
  default = 5
}

variable "waf_blocked_threshold" {
  type    = number
  default = 100
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

variable "nat_gateway_id" {
  description = "NAT Gateway ID. 비어 있으면 NAT GW 알람을 생성하지 않습니다."
  type        = string
  default     = ""
}

variable "natgw_packets_drop_threshold" {
  description = "NAT Gateway PacketsDropCount 임계값"
  type        = number
  default     = 0
}

variable "natgw_error_port_threshold" {
  description = "NAT Gateway ErrorPortAllocation 임계값"
  type        = number
  default     = 0
}

variable "cloudfront_cache_hit_rate_threshold" {
  description = "CloudFront 캐시 히트율 최소 임계값 (%). CloudFront Additional Metrics 활성화 필요."
  type        = number
  default     = 70
}

variable "cloudfront_origin_latency_threshold_ms" {
  description = "CloudFront Origin 응답시간 임계값 (ms). CloudFront Additional Metrics 활성화 필요."
  type        = number
  default     = 1000
}
