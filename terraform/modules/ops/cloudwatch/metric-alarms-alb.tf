resource "aws_cloudwatch_metric_alarm" "alb_5xx_elb" {
  alarm_name          = "${local.name_prefix}-alb-5xx-elb"
  alarm_description   = "ALB 자체 5xx 오류 발생 (LB 레벨)"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = var.alb_5xx_elb_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.ok_actions
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx_target" {
  alarm_name          = "${local.name_prefix}-alb-5xx-target"
  alarm_description   = "ALB Target(서비스) 5xx 오류 발생"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = var.alb_5xx_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.ok_actions
}

resource "aws_cloudwatch_metric_alarm" "alb_response_time" {
  alarm_name          = "${local.name_prefix}-alb-response-time"
  alarm_description   = "ALB 서비스 응답시간 임계값 초과"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = local.default_evaluation_periods
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = local.default_period
  statistic           = "Average"
  threshold           = var.alb_latency_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.ok_actions
}
