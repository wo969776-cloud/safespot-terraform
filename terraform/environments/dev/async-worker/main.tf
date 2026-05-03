module "sqs" {
  source = "../../../modules/async-worker/sqs"

  project     = var.project
  environment = var.environment
  queue_name  = var.queue_name

  visibility_timeout_seconds    = var.visibility_timeout_seconds
  message_retention_seconds     = var.message_retention_seconds
  dlq_message_retention_seconds = var.dlq_message_retention_seconds
  max_receive_count             = var.max_receive_count

  common_tags = local.common_tags
}
