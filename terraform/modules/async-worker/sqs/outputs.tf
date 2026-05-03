output "event_queue_name" {
  description = "Main event queue name."
  value       = aws_sqs_queue.event.name
}

output "event_queue_arn" {
  description = "Main event queue ARN."
  value       = aws_sqs_queue.event.arn
}

output "event_queue_url" {
  description = "Main event queue URL."
  value       = aws_sqs_queue.event.url
}

output "event_dlq_arn" {
  description = "Event dead-letter queue ARN."
  value       = aws_sqs_queue.event_dlq.arn
}

output "event_dlq_url" {
  description = "Event dead-letter queue URL."
  value       = aws_sqs_queue.event_dlq.url
}
