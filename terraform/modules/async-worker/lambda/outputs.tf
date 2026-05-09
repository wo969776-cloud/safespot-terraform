output "lambda_function_name" {
  description = "Async-worker Lambda function name."
  value       = aws_lambda_function.async_worker.function_name
}

output "lambda_function_arn" {
  description = "Async-worker Lambda function ARN."
  value       = aws_lambda_function.async_worker.arn
}

output "lambda_reserved_concurrent_executions" {
  description = "Async-worker Lambda reserved concurrent executions."
  value       = aws_lambda_function.async_worker.reserved_concurrent_executions
}
