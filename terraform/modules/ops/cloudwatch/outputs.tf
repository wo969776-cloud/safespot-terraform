output "alarm_arns" {
  description = "생성된 CloudWatch Alarm ARN 전체 map"

  value = merge(
    {
      alb_5xx_elb       = aws_cloudwatch_metric_alarm.alb_5xx_elb.arn
      alb_5xx_target    = aws_cloudwatch_metric_alarm.alb_5xx_target.arn
      alb_response_time = aws_cloudwatch_metric_alarm.alb_response_time.arn
    },

    {
      rds_cpu               = aws_cloudwatch_metric_alarm.rds_cpu.arn
      rds_connections       = aws_cloudwatch_metric_alarm.rds_connections.arn
      rds_read_latency      = aws_cloudwatch_metric_alarm.rds_read_latency.arn
      rds_write_latency     = aws_cloudwatch_metric_alarm.rds_write_latency.arn
      rds_replica_lag       = aws_cloudwatch_metric_alarm.rds_replica_lag.arn
      rds_volume_bytes_used = aws_cloudwatch_metric_alarm.rds_volume_bytes_used.arn
    },

    {
      redis_cpu              = aws_cloudwatch_metric_alarm.redis_cpu.arn
      redis_evictions        = aws_cloudwatch_metric_alarm.redis_evictions.arn
      redis_curr_connections = aws_cloudwatch_metric_alarm.redis_curr_connections.arn
      redis_freeable_memory  = aws_cloudwatch_metric_alarm.redis_memory.arn
      redis_bytes_used       = aws_cloudwatch_metric_alarm.redis_bytes_used.arn
    },

    {
      for k, v in aws_cloudwatch_metric_alarm.sqs_visible :
      "sqs_${k}_visible" => v.arn
    },

    {
      for k, v in aws_cloudwatch_metric_alarm.sqs_oldest_age :
      "sqs_${k}_oldest_age" => v.arn
    },

    {
      for k, v in aws_cloudwatch_metric_alarm.sqs_in_flight :
      "sqs_${k}_in_flight" => v.arn
    },

    {
      dlq_visible    = aws_cloudwatch_metric_alarm.dlq_visible.arn
      dlq_oldest_age = aws_cloudwatch_metric_alarm.dlq_oldest_age.arn
    },

    {
      lambda_errors                = aws_cloudwatch_metric_alarm.lambda_errors.arn
      lambda_throttles             = aws_cloudwatch_metric_alarm.lambda_throttles.arn
      lambda_duration              = aws_cloudwatch_metric_alarm.lambda_duration.arn
      lambda_concurrent_executions = aws_cloudwatch_metric_alarm.lambda_concurrent_executions.arn
    },

    {
      eks_node_cpu    = aws_cloudwatch_metric_alarm.eks_node_cpu.arn
      eks_node_memory = aws_cloudwatch_metric_alarm.eks_node_memory.arn
    },

    {
      cloudfront_5xx            = aws_cloudwatch_metric_alarm.cloudfront_5xx.arn
      cloudfront_4xx            = aws_cloudwatch_metric_alarm.cloudfront_4xx.arn
      cloudfront_cache_hit_rate = aws_cloudwatch_metric_alarm.cloudfront_cache_hit_rate.arn
      cloudfront_origin_latency = aws_cloudwatch_metric_alarm.cloudfront_origin_latency.arn
    },

    {
      waf_blocked_requests = aws_cloudwatch_metric_alarm.waf_blocked_requests.arn
    },

    var.nat_gateway_id != "" ? {
      natgw_packets_drop          = aws_cloudwatch_metric_alarm.natgw_packets_drop[0].arn
      natgw_error_port_allocation = aws_cloudwatch_metric_alarm.natgw_error_port_allocation[0].arn
    } : {}
  )
}
