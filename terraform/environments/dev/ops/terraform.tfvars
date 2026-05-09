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

# Alert email subscription target for dev ops alarms.
alert_email = "201sohyun@naver.com"

enable_observability_iam = true

# CloudWatch metric collection is handled by YACE.
# Grafana uses its own IRSA for CloudWatch datasource.
# Prometheus IRSA remains disabled unless Prometheus itself needs AWS API access.
enable_fluentbit_irsa  = false
enable_prometheus_irsa = false
enable_grafana_irsa    = true
enable_yace_irsa       = true

grafana_namespace            = "monitoring"
grafana_service_account_name = "safespot-grafana"

yace_namespace            = "monitoring"
yace_service_account_name = "safespot-yace"
