module "sqs" {
  source = "../../../modules/proactive-scale/sqs"

  project     = var.project
  environment = var.environment

  visibility_timeout_seconds    = var.visibility_timeout_seconds
  message_retention_seconds     = var.message_retention_seconds
  dlq_message_retention_seconds = var.dlq_message_retention_seconds
  max_receive_count             = var.max_receive_count

  common_tags = local.common_tags
}

module "irsa" {
  source = "../../../modules/proactive-scale/irsa"

  project     = var.project
  environment = var.environment

  eks_cluster_name = var.eks_cluster_name

  proactive_scale_queue_arn = module.sqs.queue_arn

  k8s_namespace            = "application"
  k8s_service_account_name = "proactive-scale-controller"

  common_tags = local.common_tags
}
