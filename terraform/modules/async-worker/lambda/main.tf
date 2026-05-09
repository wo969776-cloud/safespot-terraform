# ── IAM Role ─────────────────────────────────────────────────────
resource "aws_iam_role" "async_worker" {
  name = "${var.project}-${var.environment}-async-worker-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-async-worker-lambda-role"
  })
}

# VPC 접근 포함 기본 실행 권한 (CloudWatch Logs + ENI 생성)
resource "aws_iam_role_policy_attachment" "vpc_execution" {
  role       = aws_iam_role.async_worker.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# CloudWatch: METRICS_NAMESPACE 설정 시 PutMetricData 권한 필요
resource "aws_iam_role_policy" "cloudwatch_metrics" {
  name = "${var.project}-${var.environment}-async-worker-lambda-cloudwatch-policy"
  role = aws_iam_role.async_worker.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["cloudwatch:PutMetricData"]
      Resource = "*"
    }]
  })
}

# SQS: event source mapping 처리에 필요한 최소 권한
resource "aws_iam_role_policy" "sqs" {
  name = "${var.project}-${var.environment}-async-worker-lambda-sqs-policy"
  role = aws_iam_role.async_worker.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:ChangeMessageVisibility"
      ]
      Resource = [
        var.cache_refresh_queue_arn,
        var.readmodel_refresh_queue_arn,
        var.environment_cache_refresh_queue_arn
      ]
    }]
  })
}

# ── Lambda Function ───────────────────────────────────────────────
resource "aws_lambda_function" "async_worker" {
  function_name = "${var.project}-${var.environment}-async-worker"
  role          = aws_iam_role.async_worker.arn

  runtime     = "java21"
  handler     = var.lambda_handler
  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory_size

  reserved_concurrent_executions = var.reserved_concurrent_executions

  filename         = var.lambda_filename
  source_code_hash = filebase64sha256(var.lambda_filename)

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.lambda_sg_id]
  }

  environment {
    variables = {
      DB_HOST           = var.db_host
      DB_PORT           = tostring(var.db_port)
      DB_NAME           = var.db_name
      DB_USER           = var.db_user
      DB_PASSWORD       = var.db_password
      REDIS_HOST        = var.redis_host
      REDIS_PORT        = "6379"
      METRICS_NAMESPACE = var.metrics_namespace
    }
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-async-worker"
  })
}

# ── Event Source Mappings ─────────────────────────────────────────
# ReportBatchItemFailures: partial batch failure 허용 — 실패 message만 retry

resource "aws_lambda_event_source_mapping" "cache_refresh" {
  event_source_arn                   = var.cache_refresh_queue_arn
  function_name                      = aws_lambda_function.async_worker.arn
  batch_size                         = var.batch_size
  maximum_batching_window_in_seconds = var.maximum_batching_window_in_seconds
  function_response_types            = ["ReportBatchItemFailures"]
  enabled                            = true
}

resource "aws_lambda_event_source_mapping" "readmodel_refresh" {
  event_source_arn                   = var.readmodel_refresh_queue_arn
  function_name                      = aws_lambda_function.async_worker.arn
  batch_size                         = var.batch_size
  maximum_batching_window_in_seconds = var.maximum_batching_window_in_seconds
  function_response_types            = ["ReportBatchItemFailures"]
  enabled                            = true
}

resource "aws_lambda_event_source_mapping" "environment_cache_refresh" {
  event_source_arn                   = var.environment_cache_refresh_queue_arn
  function_name                      = aws_lambda_function.async_worker.arn
  batch_size                         = var.batch_size
  maximum_batching_window_in_seconds = var.maximum_batching_window_in_seconds
  function_response_types            = ["ReportBatchItemFailures"]
  enabled                            = true
}
