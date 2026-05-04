# modules/ops/observability-iam/locals.tf

locals {
  name_prefix = "safespot-${var.env}"

  # OIDC Provider URL에서 https:// 제거
  # IRSA condition StringEquals key에 사용
  # 형식: oidc.eks.ap-northeast-2.amazonaws.com/id/EXAMPLED...
  oidc_provider_url_stripped = replace(var.eks_oidc_provider_url, "https://", "")

  # ── IRSA assume role condition 헬퍼 ─────────────────────────────────────────
  # 각 ServiceAccount의 sub claim 형식:
  #   system:serviceaccount:{namespace}:{service_account_name}

  prometheus_sa_sub = "system:serviceaccount:${var.prometheus_namespace}:${var.prometheus_service_account_name}"
  grafana_sa_sub    = "system:serviceaccount:${var.grafana_namespace}:${var.grafana_service_account_name}"
  fluentbit_sa_sub  = "system:serviceaccount:${var.fluentbit_namespace}:${var.fluentbit_service_account_name}"

  # Fluent Bit write 대상 Log Group ARN
  # var.log_group_arns가 비어있으면 와일드카드로 fallback
  # TODO: log-groups 모듈 apply 후 실제 ARN 목록을 연결할 것
  #       와일드카드 사용은 최소 권한 원칙에 위배되므로
  #       운영 환경에서는 반드시 실제 ARN 목록으로 교체할 것
  fluentbit_log_group_arns = length(var.log_group_arns) > 0 ? var.log_group_arns : ["*"]
}