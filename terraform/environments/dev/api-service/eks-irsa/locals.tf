locals {
  domain    = "api-service"
  component = "eks-irsa"

  cluster_name      = data.terraform_remote_state.eks_core.outputs.cluster_name
  oidc_provider_arn = data.terraform_remote_state.eks_core.outputs.oidc_provider_arn
  oidc_provider     = data.terraform_remote_state.eks_core.outputs.oidc_provider

  alb_controller_role_name   = "${var.project}-${var.env}-api-service-iam-role-alb-controller"
  alb_controller_policy_name = "${var.project}-${var.env}-api-service-iam-policy-alb-controller"

  api_core_role_name   = "${var.project}-${var.env}-api-service-iam-role-api-core"
  api_core_policy_name = "${var.project}-${var.env}-api-service-iam-policy-api-core-sqs"

  api_public_read_role_name   = "${var.project}-${var.env}-api-service-iam-role-api-public-read"
  api_public_read_policy_name = "${var.project}-${var.env}-api-service-iam-policy-api-public-read-sqs"

  external_ingestion_role_name   = "${var.project}-${var.env}-api-service-iam-role-external-ingestion"
  external_ingestion_policy_name = "${var.project}-${var.env}-api-service-iam-policy-external-ingestion-sqs"

  pre_scaling_controller_role_name = "${var.project}-${var.env}-api-service-iam-role-pre-scaling-controller"

  api_core_event_queue_arn = data.terraform_remote_state.async_worker.outputs.event_queue_arn

  api_public_read_cache_refresh_queue_arn = data.terraform_remote_state.async_worker.outputs.cache_refresh_queue_arn

  external_ingestion_cache_refresh_queue_arn             = data.terraform_remote_state.async_worker.outputs.cache_refresh_queue_arn
  external_ingestion_environment_cache_refresh_queue_arn = data.terraform_remote_state.async_worker.outputs.environment_cache_refresh_queue_arn

  common_tags = {
    Project     = var.project
    Environment = var.env
    Domain      = local.domain
    Component   = local.component
    ManagedBy   = "terraform"
    Service     = var.project
    CostCenter  = "${var.project}-${var.env}"
  }
}
