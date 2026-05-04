resource "aws_cloudwatch_log_group" "lambda" {
  count = var.lambda_function_name != null && trimspace(var.lambda_function_name) != "" ? 1 : 0

  name              = local.lambda_log_group_name
  retention_in_days = var.lambda_retention_days
  kms_key_id        = local.kms_key_arn

  tags = {
    Name      = local.lambda_log_group_name
    LogType   = "lambda"
    Component = "async-worker"
    Purpose   = "async-worker-execution-log"
  }
}