# modules/ops/cloudwatch/metric-alarms-redis.tf

resource "aws_cloudwatch_metric_alarm" "redis_cpu" {
  alarm_name          = "${local.name_prefix}-redis-cpu"
  alarm_description   = "ElastiCache Engine CPU 임계값 초과"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "EngineCPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = 60
  statistic           = "Average"
  threshold           = var.redis_cpu_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    ReplicationGroupId = var.redis_cluster_id
  }

  alarm_actions = local.alarm_actions
  ok_actions    = []
}

resource "aws_cloudwatch_metric_alarm" "redis_evictions" {
  alarm_name          = "${local.name_prefix}-redis-evictions"
  alarm_description   = "ElastiCache Eviction 발생"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "Evictions"
  namespace           = "AWS/ElastiCache"
  period              = 60
  statistic           = "Sum"
  threshold           = var.redis_evictions_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    ReplicationGroupId = var.redis_cluster_id
  }

  alarm_actions = local.alarm_actions
  ok_actions    = []
}

resource "aws_cloudwatch_metric_alarm" "redis_curr_connections" {
  alarm_name          = "${local.name_prefix}-redis-curr-connections"
  alarm_description   = "ElastiCache 연결 수 임계값 초과"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CurrConnections"
  namespace           = "AWS/ElastiCache"
  period              = 60
  statistic           = "Maximum"
  threshold           = var.redis_curr_connections_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    ReplicationGroupId = var.redis_cluster_id
  }

  alarm_actions = local.alarm_actions
  ok_actions    = []
}

resource "aws_cloudwatch_metric_alarm" "redis_memory" {
  alarm_name          = "${local.name_prefix}-redis-freeable-memory"
  alarm_description   = "ElastiCache 가용 메모리 부족 (FreeableMemory 임계값 미달)"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 3
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = 60
  statistic           = "Minimum"
  threshold           = var.redis_freeable_memory_threshold_bytes
  treat_missing_data  = "notBreaching"

  dimensions = {
    ReplicationGroupId = var.redis_cluster_id
  }

  alarm_actions = local.alarm_actions
  ok_actions    = []
}

resource "aws_cloudwatch_metric_alarm" "redis_bytes_used" {
  alarm_name          = "${local.name_prefix}-redis-bytes-used"
  alarm_description   = "ElastiCache 캐시 사용 메모리 임계값 초과"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "BytesUsedForCache"
  namespace           = "AWS/ElastiCache"
  period              = 60
  statistic           = "Maximum"
  threshold           = var.redis_bytes_used_threshold_bytes
  treat_missing_data  = "notBreaching"

  dimensions = {
    ReplicationGroupId = var.redis_cluster_id
  }

  alarm_actions = local.alarm_actions
  ok_actions    = []
}