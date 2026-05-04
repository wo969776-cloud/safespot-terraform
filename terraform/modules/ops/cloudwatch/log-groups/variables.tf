# modules/ops/log-groups/variables.tf

variable "env" {
  description = "배포 환경 (dev / stg / prod)"
  type        = string
}

# ── 공통 ──────────────────────────────────────────────────────────────────────

variable "retention_days" {
  description = <<-EOT
    CloudWatch Log Group 기본 보존 기간 (일).
    monitoring.md 기준 30일 권장.
    0 = 영구 보존 (비용 주의)
    유효값: 1,3,5,7,14,30,60,90,120,150,180,365,400,545,731,1096,1827,2192,2557,2922,3288,3653
  EOT
  type    = number
  default = 30

  validation {
    condition = contains(
      [0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400,
      545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653],
      var.retention_days
    )
    error_message = "retention_days는 CloudWatch 허용 값 중 하나여야 합니다."
  }
}

variable "lambda_retention_days" {
  description = <<-EOT
    Lambda Log Group 보존 기간 (일).
    Lambda 로그는 DLQ 디버깅 등 재처리 목적으로
    기본 보존 기간보다 길게 유지하는 것을 권장.
  EOT
  type    = number
  default = 60

  validation {
    condition = contains(
      [0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400,
      545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653],
      var.lambda_retention_days
    )
    error_message = "lambda_retention_days는 CloudWatch 허용 값 중 하나여야 합니다."
  }
}

variable "eks_control_plane_retention_days" {
  description = <<-EOT
    EKS control plane Log Group 보존 기간 (일).
    보안 감사 목적으로 기본보다 길게 유지 권장.
  EOT
  type    = number
  default = 90

  validation {
    condition = contains(
      [0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400,
      545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653],
      var.eks_control_plane_retention_days
    )
    error_message = "eks_control_plane_retention_days는 CloudWatch 허용 값 중 하나여야 합니다."
  }
}

# ── EKS ───────────────────────────────────────────────────────────────────────

variable "eks_cluster_name" {
  description = <<-EOT
    EKS 클러스터 이름.
    EKS control plane log group 이름 생성에 사용.
    AWS 규칙: /aws/eks/{cluster_name}/cluster 형식 고정.
    compute 파트 remote state output에서 참조.
  EOT
  type = string
}

variable "eks_log_types" {
  description = <<-EOT
    EKS control plane 로그 활성화 유형.
    monitoring.md: EKS control plane 로그 수집 대상.
    api            : API server 요청/응답
    audit          : 보안 감사 로그 (누가 무엇을 했는지)
    authenticator  : 인증 로그
    controllerManager : 컨트롤러 동작 로그
    scheduler      : Pod 스케줄링 로그
    TODO: prod 환경에서는 전체 활성화 권장.
          dev에서 비용이 부담되면 api, audit 만 활성화.
  EOT
  type    = list(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

# ── Lambda ────────────────────────────────────────────────────────────────────

variable "lambda_function_name" {
  description = <<-EOT
    async-worker Lambda 함수 이름.
    Lambda Log Group 이름 생성에 사용.
    AWS 규칙: /aws/lambda/{function_name} 형식 고정.
    async-worker 파트 remote state output에서 참조.
  EOT
  type = string
}

# ── ALB ───────────────────────────────────────────────────────────────────────

variable "alb_log_bucket_name" {
  description = <<-EOT
    ALB access log를 저장할 S3 버킷 이름.
    ALB access log는 CloudWatch Logs가 아닌 S3에 저장된다.
    이 모듈은 S3 버킷 자체를 생성하지 않고
    버킷 이름만 받아서 Log Group 이름 tag 등에 활용한다.
    TODO: network 파트 또는 별도 S3 파트에서
          ALB access log 버킷을 생성하고 이름을 전달할 것.
          버킷 정책에 ALB 서비스 계정 write 권한이 있어야 함.
  EOT
  type    = string
  default = ""
}

variable "enable_alb_log_group" {
  description = <<-EOT
    ALB access log용 CloudWatch Log Group 생성 여부.
    ALB → S3 방식이면 false (기본값).
    ALB → CloudWatch Logs 직접 전송 방식이면 true.
    TODO: ALB access log 수집 방식 확정 후 설정할 것.
          현재 기본값 false = S3 방식 사용.
  EOT
  type    = bool
  default = false
}

# ── Application ───────────────────────────────────────────────────────────────

variable "services" {
  description = <<-EOT
    Application Log Group을 생성할 서비스 이름 목록.
    monitoring.md 기준 4개 서비스:
    api-core, api-public-read, external-ingestion, async-worker
  EOT
  type = list(string)
  default = [
    "api-core",
    "api-public-read",
    "external-ingestion",
    "async-worker",
  ]
}

# ── KMS ───────────────────────────────────────────────────────────────────────

variable "kms_key_arn" {
  description = <<-EOT
    Log Group 암호화에 사용할 KMS Key ARN.
    비워두면 AWS 관리형 키 사용 (암호화 미적용).
    TODO: 보안 요구사항에 따라 고객 관리형 KMS Key ARN을 지정할 것.
          security 파트 또는 data 파트에서 KMS Key를 생성하고 ARN을 전달.
  EOT
  type    = string
  default = ""
}