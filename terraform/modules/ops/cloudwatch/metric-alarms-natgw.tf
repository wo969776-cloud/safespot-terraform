# AWS/NatGateway 네임스페이스 메트릭.
# nat_gateway_id는 필수 변수이므로 NAT GW가 없는 환경에서는 반드시 실제 ID를 지정해야 한다.
#
# AvailableIpAddressCount(서브넷 잔여 IP)는 AWS 네이티브 CloudWatch 메트릭이 아니다.
# Subnet 잔여 IP 모니터링이 필요하면 Lambda + EventBridge로 커스텀 메트릭을 발행해야 한다.

resource "aws_cloudwatch_metric_alarm" "natgw_packets_drop" {
  count = var.nat_gateway_id != "" ? 1 : 0

  alarm_name          = "${local.name_prefix}-natgw-packets-drop"
  alarm_description   = "NAT Gateway 패킷 드롭 발생"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "PacketsDropCount"
  namespace           = "AWS/NatGateway"
  period              = 60
  statistic           = "Sum"
  threshold           = var.natgw_packets_drop_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    NatGatewayId = var.nat_gateway_id
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.ok_actions
}

resource "aws_cloudwatch_metric_alarm" "natgw_error_port_allocation" {
  count = var.nat_gateway_id != "" ? 1 : 0

  alarm_name          = "${local.name_prefix}-natgw-error-port-allocation"
  alarm_description   = "NAT Gateway 포트 할당 실패 발생"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ErrorPortAllocation"
  namespace           = "AWS/NatGateway"
  period              = 60
  statistic           = "Sum"
  threshold           = var.natgw_error_port_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    NatGatewayId = var.nat_gateway_id
  }

  alarm_actions = local.alarm_actions
  ok_actions    = local.ok_actions
}
