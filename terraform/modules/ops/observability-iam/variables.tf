# modules/ops/observability-iam/variables.tf

variable "project" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

# ── EKS OIDC ──────────────────────────────────────────────────────────────────
# IRSA(IAM Roles for Service Accounts) 구성에 필요
# compute 파트 remote state output에서 참조

variable "eks_oidc_provider_url" {
  description = <<-EOT
    EKS OIDC Provider URL.
    형식: https://oidc.eks.ap-northeast-2.amazonaws.com/id/EXAMPLED539D4633E53DE1B716D3041E
    compute 파트 remote state output에서 참조.
    IRSA assume role condition에 사용.
  EOT
  type        = string
}

variable "eks_oidc_provider_arn" {
  description = <<-EOT
    EKS OIDC Provider ARN.
    형식: arn:aws:iam::123456789012:oidc-provider/oidc.eks...
    compute 파트 remote state output에서 참조.
    IRSA assume role principal에 사용.
  EOT
  type        = string
}

# ── Namespace ─────────────────────────────────────────────────────────────────

variable "prometheus_namespace" {
  description = <<-EOT
    Prometheus가 배포된 Kubernetes namespace.
    IRSA condition의 sub claim에 사용.
    형식: system:serviceaccount:{namespace}:{service_account_name}
    TODO: observability Helm chart 배포 시 사용할 namespace와 반드시 일치시킬 것.
  EOT
  type        = string
  default     = "monitoring"
}

variable "prometheus_service_account_name" {
  description = <<-EOT
    Prometheus ServiceAccount 이름.
    IRSA condition의 sub claim에 사용.
    TODO: observability Helm chart(kube-prometheus-stack 등)의
          prometheus.serviceAccount.name 값과 반드시 일치시킬 것.
          기본값은 kube-prometheus-stack 기준.
  EOT
  type        = string
  default     = "prometheus"
}

variable "grafana_namespace" {
  description = <<-EOT
    Grafana가 배포된 Kubernetes namespace.
    TODO: observability Helm chart 배포 시 사용할 namespace와 반드시 일치시킬 것.
          Prometheus와 같은 namespace를 쓰는 경우가 많으므로 확인 필요.
  EOT
  type        = string
  default     = "monitoring"
}

variable "grafana_service_account_name" {
  description = <<-EOT
    Grafana ServiceAccount 이름.
    IRSA condition의 sub claim에 사용.
    TODO: observability Helm chart의
          grafana.serviceAccount.name 값과 반드시 일치시킬 것.
  EOT
  type        = string
  default     = "safespot-grafana"
}

variable "fluentbit_namespace" {
  description = <<-EOT
    Fluent Bit이 배포된 Kubernetes namespace.
    monitoring.md: Application log → Fluent Bit → CloudWatch Logs
    TODO: Fluent Bit Helm chart 배포 시 사용할 namespace와 반드시 일치시킬 것.
  EOT
  type        = string
  default     = "logging"
}

variable "fluentbit_service_account_name" {
  description = <<-EOT
    Fluent Bit ServiceAccount 이름.
    TODO: Fluent Bit Helm chart의
          serviceAccount.name 값과 반드시 일치시킬 것.
  EOT
  type        = string
  default     = "fluent-bit"
}

variable "yace_namespace" {
  description = "YACE가 배포될 Kubernetes namespace."
  type        = string
  default     = "monitoring"
}

variable "yace_service_account_name" {
  description = "YACE ServiceAccount 이름."
  type        = string
  default     = "safespot-yace"
}

# ── CloudWatch Log Group ARN ──────────────────────────────────────────────────

variable "log_group_arns" {
  description = <<-EOT
    Fluent Bit이 write 권한을 가져야 할 CloudWatch Log Group ARN 목록.
    log-groups 모듈의 all_log_group_arns output에서 참조.
    최소 권한 원칙: 전체 와일드카드(*) 대신 실제 Log Group ARN만 지정.
    TODO: log-groups 모듈 apply 완료 후
          ops remote state output에서 참조하도록 연결할 것.
  EOT
  type        = list(string)
  default     = []
}

# ── 기능 활성화 플래그 ────────────────────────────────────────────────────────

variable "enable_grafana_irsa" {
  description = <<-EOT
    Grafana CloudWatch datasource용 IRSA Role 생성 여부.
    Grafana가 Prometheus만 datasource로 사용하면 false.
    Grafana → CloudWatch 직접 연동 시 true로 변경.
    TODO: observability chart 설계 확정 후 결정할 것.
  EOT
  type        = bool
  default     = false
}

variable "enable_prometheus_irsa" {
  description = <<-EOT
    Prometheus CloudWatch exporter용 IRSA Role 생성 여부.
    CloudWatch exporter를 사용하지 않으면 false.
    monitoring.md: ALB/EKS metric → CloudWatch / Prometheus 병행 수집 구조
    TODO: observability chart에서 CloudWatch exporter 사용 여부 확정 후 결정할 것.
  EOT
  type        = bool
  default     = false
}

variable "enable_fluentbit_irsa" {
  description = <<-EOT
    Fluent Bit CloudWatch Logs write용 IRSA Role 생성 여부.
    monitoring.md: Application log → Fluent Bit → CloudWatch Logs
    Fluent Bit을 배포할 예정이면 true.
    TODO: logging chart 설계 확정 후 true로 변경할 것.
  EOT
  type        = bool
  default     = false
}

variable "enable_yace_irsa" {
  description = "YACE CloudWatch metric read용 IRSA Role 생성 여부."
  type        = bool
  default     = false
}
