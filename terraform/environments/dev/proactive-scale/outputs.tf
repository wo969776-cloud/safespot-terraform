output "queue_name" {
  description = "Proactive scale queue name."
  value       = module.sqs.queue_name
}

output "queue_url" {
  description = "Proactive scale queue URL. K8s ConfigMap SCALE_SQS_QUEUE_URL에 사용."
  value       = module.sqs.queue_url
}

output "queue_arn" {
  description = "Proactive scale queue ARN."
  value       = module.sqs.queue_arn
}

output "dlq_name" {
  description = "Proactive scale DLQ name."
  value       = module.sqs.dlq_name
}

output "dlq_url" {
  description = "Proactive scale DLQ URL."
  value       = module.sqs.dlq_url
}

output "dlq_arn" {
  description = "Proactive scale DLQ ARN. CloudWatch Alarm 및 dead-letter policy 참조용."
  value       = module.sqs.dlq_arn
}

output "irsa_role_arn" {
  description = "IRSA IAM Role ARN. K8s ServiceAccount eks.amazonaws.com/role-arn annotation에 사용."
  value       = module.irsa.irsa_role_arn
}
