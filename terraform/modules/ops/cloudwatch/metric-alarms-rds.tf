resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "${local.name_prefix}-rds-cpu"
  alarm_description   = "RDS CPU 사용률 임계값 초과"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = local.default_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = local.default_period
  statistic           = "Average"
  threshold           = var.rds_cpu_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBClusterIdentifier = var.rds_cluster_identifier
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.ok_actions
}

resource "aws_cloudwatch_metric_alarm" "rds_connections" {
  alarm_name          = "${local.name_prefix}-rds-connections"
  alarm_description   = "RDS DB 연결 수 임계값 초과"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = local.default_evaluation_periods
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = local.default_period
  statistic           = "Maximum"
  threshold           = var.rds_connections_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBClusterIdentifier = var.rds_cluster_identifier
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.ok_actions
}

resource "aws_cloudwatch_metric_alarm" "rds_read_latency" {
  alarm_name          = "${local.name_prefix}-rds-read-latency"
  alarm_description   = "RDS Read Latency 임계값 초과"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = local.default_evaluation_periods
  metric_name         = "ReadLatency"
  namespace           = "AWS/RDS"
  period              = local.default_period
  statistic           = "Average"
  threshold           = var.rds_read_latency_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBClusterIdentifier = var.rds_cluster_identifier
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.ok_actions
}

resource "aws_cloudwatch_metric_alarm" "rds_write_latency" {
  alarm_name          = "${local.name_prefix}-rds-write-latency"
  alarm_description   = "RDS Write Latency 임계값 초과"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = local.default_evaluation_periods
  metric_name         = "WriteLatency"
  namespace           = "AWS/RDS"
  period              = local.default_period
  statistic           = "Average"
  threshold           = var.rds_write_latency_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBClusterIdentifier = var.rds_cluster_identifier
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.ok_actions
}

# [FIX-FATAL-2] Deadlocks metric은 Aurora PostgreSQL에 존재하지 않음 (MySQL 전용)
# → Aurora PostgreSQL은 pg_log 기반 CloudWatch Logs Insights로 deadlock 감지
# → 해당 metric alarm 제거, Aurora 전용 replica lag 알람으로 대체
resource "aws_cloudwatch_metric_alarm" "rds_replica_lag" {
  alarm_name          = "${local.name_prefix}-rds-replica-lag"
  alarm_description   = "Aurora 복제 지연 임계값 초과"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = local.default_evaluation_periods
  metric_name         = "AuroraReplicaLag"
  namespace           = "AWS/RDS"
  period              = local.default_period
  statistic           = "Maximum"
  threshold           = var.rds_replica_lag_threshold_ms
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBClusterIdentifier = var.rds_cluster_identifier
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.ok_actions
}

# Aurora PostgreSQL의 실제 스토리지 사용량
resource "aws_cloudwatch_metric_alarm" "rds_volume_bytes_used" {
  alarm_name          = "${local.name_prefix}-rds-volume-bytes-used"
  alarm_description   = "Aurora 스토리지 사용량 임계값 초과"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = local.default_evaluation_periods
  metric_name         = "VolumeBytesUsed"
  namespace           = "AWS/RDS"
  period              = local.default_period
  statistic           = "Maximum"
  threshold           = var.rds_volume_bytes_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBClusterIdentifier = var.rds_cluster_identifier
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.ok_actions
}