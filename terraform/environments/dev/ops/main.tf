# [변경] api-service remote state key 수정
#        dev/api-service/terraform.tfstate
#        → environments/dev/api-service/eks-core/terraform.tfstate
#
# [변경] alb_arn_suffix / alb_log_bucket_name 관련 locals 및 network remote state 참조 삭제
#
# [변경] try() 전부 제거

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "api_service" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "environments/${var.environment}/api-service/eks-core/terraform.tfstate"
    region = var.remote_state_region
  }
}

data "terraform_remote_state" "data_layer" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "environments/${var.environment}/data/terraform.tfstate"
    region = var.remote_state_region
  }
}

data "terraform_remote_state" "async_worker" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "environments/${var.environment}/async-worker/terraform.tfstate"
    region = var.remote_state_region
  }
}

data "terraform_remote_state" "front_edge" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "environments/${var.environment}/edge/terraform.tfstate"
    region = var.remote_state_region
  }
}

locals {
  # [삭제] alb_arn_suffix, alb_log_bucket_name 제거

  rds_cluster_identifier = data.terraform_remote_state.data_layer.outputs.rds_cluster_identifier
  redis_cluster_id       = data.terraform_remote_state.data_layer.outputs.redis_cluster_id

  sqs_queues = {
    cache_refresh = data.terraform_remote_state.async_worker.outputs.sqs_queue_name_cache_refresh
    readmodel     = data.terraform_remote_state.async_worker.outputs.sqs_queue_name_readmodel
    env_cache     = data.terraform_remote_state.async_worker.outputs.sqs_queue_name_env_cache
    dlq           = data.terraform_remote_state.async_worker.outputs.sqs_dlq_name
  }

  lambda_function_name = data.terraform_remote_state.async_worker.outputs.lambda_function_name

  lambda_reserved_concurrent_executions = data.terraform_remote_state.async_worker.outputs.lambda_reserved_concurrent_executions

  lambda_concurrent_executions_threshold = (
    local.lambda_reserved_concurrent_executions > 0
    ? floor(local.lambda_reserved_concurrent_executions * 0.8)
    : 80
  )

  # [변경] output 이름 수정
  #   eks_cluster_name      → cluster_name
  #   eks_oidc_provider_url → oidc_provider
  #   eks_oidc_provider_arn → oidc_provider_arn
  eks_cluster_name      = data.terraform_remote_state.api_service.outputs.cluster_name
  eks_oidc_provider_url = data.terraform_remote_state.api_service.outputs.oidc_provider
  eks_oidc_provider_arn = data.terraform_remote_state.api_service.outputs.oidc_provider_arn

  cloudfront_distribution_id = (
    var.cloudfront_distribution_id != ""
    ? var.cloudfront_distribution_id
    : data.terraform_remote_state.front_edge.outputs.cloudfront_distribution_id
  )

  waf_acl_name = (
    var.waf_acl_name != ""
    ? var.waf_acl_name
    : data.terraform_remote_state.front_edge.outputs.waf_acl_name
  )
}

module "log_bucket" {
  source = "../../../modules/ops/log-bucket"

  project        = var.project
  environment    = var.environment
  aws_account_id = data.aws_caller_identity.current.account_id
  force_destroy  = var.log_bucket_force_destroy

  alb_retention_days        = var.alb_log_retention_days
  waf_retention_days        = var.waf_log_retention_days
  vpc_flow_retention_days   = var.vpc_flow_log_retention_days
  rds_retention_days        = var.rds_log_retention_days
  cloudwatch_retention_days = var.cloudwatch_log_retention_days

  enable_versioning = var.log_bucket_enable_versioning
  kms_key_arn       = var.kms_key_arn
}

module "ecr" {
  source = "../../../modules/ops/ecr"

  project              = var.project
  environment          = var.environment
  domain               = local.domain
  services             = var.services
  image_tag_mutability = var.image_tag_mutability
  scan_on_push         = var.scan_on_push
  max_image_count      = var.max_image_count
  untagged_expiry_days = var.untagged_expiry_days
}

module "alerting" {
  source = "../../../modules/ops/alerting"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  project                            = var.project
  environment                        = var.environment
  alert_email                        = var.alert_email
  additional_email_subscriptions     = var.additional_email_subscriptions
  slack_webhook_secret_name          = var.slack_webhook_secret_name
  slack_webhook_url                  = var.slack_webhook_url
  enable_slack_secret                = var.enable_slack_secret
  slack_webhook_recovery_window_days = var.slack_webhook_recovery_window_days
}

module "cloudwatch" {
  source = "../../../modules/ops/cloudwatch"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  project            = var.project
  environment        = var.environment
  sns_topic_arn      = module.alerting.sns_topic_arn
  edge_sns_topic_arn = module.alerting.edge_sns_topic_arn

  alb_arn_suffix        = var.alb_arn_suffix
  alb_5xx_elb_threshold = var.alb_5xx_elb_threshold
  alb_5xx_threshold     = var.alb_5xx_threshold
  alb_4xx_threshold     = var.alb_4xx_threshold
  alb_latency_threshold = var.alb_latency_threshold_seconds

  nat_gateway_id               = var.nat_gateway_id
  natgw_packets_drop_threshold = var.natgw_packets_drop_threshold
  natgw_error_port_threshold   = var.natgw_error_port_threshold

  sqs_in_flight_threshold = var.sqs_in_flight_threshold

  cloudfront_cache_hit_rate_threshold    = var.cloudfront_cache_hit_rate_threshold
  cloudfront_origin_latency_threshold_ms = var.cloudfront_origin_latency_threshold_ms

  rds_cluster_identifier           = local.rds_cluster_identifier
  rds_cpu_threshold                = var.rds_cpu_threshold
  rds_connections_threshold        = var.rds_connections_threshold
  rds_free_storage_threshold_bytes = var.rds_free_storage_threshold_bytes
  rds_replica_lag_threshold_ms     = var.rds_replica_lag_threshold_ms
  rds_volume_bytes_threshold       = var.rds_volume_bytes_threshold

  redis_cluster_id                      = local.redis_cluster_id
  redis_cpu_threshold                   = var.redis_cpu_threshold
  redis_evictions_threshold             = var.redis_evictions_threshold
  redis_curr_connections_threshold      = var.redis_curr_connections_threshold
  redis_memory_threshold                = var.redis_memory_threshold
  redis_freeable_memory_threshold_bytes = var.redis_freeable_memory_threshold_bytes
  redis_bytes_used_threshold_bytes      = var.redis_bytes_used_threshold_bytes

  sqs_queue_names           = local.sqs_queues
  sqs_visible_threshold     = var.sqs_visible_threshold
  sqs_age_threshold_seconds = var.sqs_age_threshold_seconds
  dlq_visible_threshold     = var.dlq_visible_threshold
  dlq_age_threshold_seconds = var.dlq_age_threshold_seconds

  lambda_function_name                   = local.lambda_function_name
  lambda_error_threshold                 = var.lambda_error_threshold
  lambda_throttle_threshold              = var.lambda_throttle_threshold
  lambda_duration_threshold_ms           = var.lambda_duration_p99_threshold_ms
  lambda_concurrent_executions_threshold = local.lambda_concurrent_executions_threshold

  eks_cluster_name          = local.eks_cluster_name
  eks_pod_restart_threshold = var.eks_pod_restart_threshold
  eks_node_cpu_threshold    = var.eks_node_cpu_threshold
  eks_node_memory_threshold = var.eks_node_memory_threshold

  cloudfront_distribution_id = local.cloudfront_distribution_id
  waf_acl_name               = local.waf_acl_name
}

module "log_groups" {
  source = "../../../modules/ops/log-groups"

  project                          = var.project
  environment                      = var.environment
  services                         = var.services
  retention_days                   = var.log_retention_days
  eks_cluster_name                 = local.eks_cluster_name
  lambda_function_name             = local.lambda_function_name
  lambda_retention_days            = var.lambda_retention_days
  eks_control_plane_retention_days = var.eks_control_plane_retention_days
  eks_log_types                    = var.eks_log_types
  enable_alb_log_group             = var.enable_alb_log_group
  kms_key_arn                      = var.kms_key_arn
}

module "observability_iam" {
  count  = var.enable_observability_iam ? 1 : 0
  source = "../../../modules/ops/observability-iam"

  project                         = var.project
  environment                     = var.environment
  eks_oidc_provider_url           = local.eks_oidc_provider_url
  eks_oidc_provider_arn           = local.eks_oidc_provider_arn
  prometheus_namespace            = var.prometheus_k8s_namespace
  prometheus_service_account_name = var.prometheus_service_account_name
  grafana_namespace               = var.grafana_namespace
  grafana_service_account_name    = var.grafana_service_account_name
  fluentbit_namespace             = var.fluentbit_namespace
  fluentbit_service_account_name  = var.fluentbit_service_account_name
  yace_namespace                  = var.yace_namespace
  yace_service_account_name       = var.yace_service_account_name
  enable_grafana_irsa             = var.enable_grafana_irsa
  enable_prometheus_irsa          = var.enable_prometheus_irsa
  enable_fluentbit_irsa           = var.enable_fluentbit_irsa
  enable_yace_irsa                = var.enable_yace_irsa
  log_group_arns                  = module.log_groups.all_log_group_arns
}
