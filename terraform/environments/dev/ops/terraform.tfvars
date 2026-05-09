aws_region          = "ap-northeast-2"
environment         = "dev"
project             = "safespot"
remote_state_bucket = "safespot-terraform-state"
remote_state_region = "ap-northeast-2"

services = [
  "api-core",
  "api-public-read",
  "external-ingestion",
  "async-worker",
]

log_retention_days = 30

# TODO: 아래 네 값을 실제 인프라 값으로 교체한 후 apply
alert_email    = "201sohyun@naver.com"

enable_observability_iam = true
# 아래 세 플래그는 실제 ServiceAccount annotation 적용(Helm values/ArgoCD app) 확정 후 활성화
enable_fluentbit_irsa  = false
enable_prometheus_irsa = false
enable_grafana_irsa    = true
enable_yace_irsa       = true

grafana_namespace            = "monitoring"
grafana_service_account_name = "safespot-grafana"

yace_namespace            = "monitoring"
yace_service_account_name = "safespot-yace"
