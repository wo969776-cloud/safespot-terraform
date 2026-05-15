# modules/ops/cloudwatch/metric-alarms-eks.tf
#
# EKS 노드 수준 알람은 Container Insights 활성화 없이도 동작하는
# AWS/EKS namespace metric을 사용한다.
#
# pod_number_of_container_restarts는 Container Insights + 올바른 dimension 조합
# (ClusterName + Namespace + PodName)이 필요하므로 ClusterName 단독으로는 동작하지 않는다.
# EKS pod 수준 알람은 Prometheus + AlertManager로 감지하는 것을 권장한다.
# monitoring.md 섹션 1: Dashboard/alert → Grafana + AlertManager 병행 구조 참조.

resource "aws_cloudwatch_metric_alarm" "eks_node_cpu" {
  alarm_name          = "${local.name_prefix}-eks-node-cpu"
  alarm_description   = "EKS 노드 CPU 사용률 임계값 초과 (Container Insights)"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "node_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = 60
  statistic           = "Average"
  threshold           = var.eks_node_cpu_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = var.eks_cluster_name
  }

  alarm_actions = local.alarm_actions
  ok_actions    = []
}

resource "aws_cloudwatch_metric_alarm" "eks_node_memory" {
  alarm_name          = "${local.name_prefix}-eks-node-memory"
  alarm_description   = "EKS 노드 메모리 사용률 임계값 초과 (Container Insights)"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "node_memory_utilization"
  namespace           = "ContainerInsights"
  period              = 60
  statistic           = "Average"
  threshold           = var.eks_node_memory_threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = var.eks_cluster_name
  }

  alarm_actions = local.alarm_actions
  ok_actions    = []
}

# ── Pod restart 알람 참고 ────────────────────────────────────────────────────
# pod_number_of_container_restarts는 ClusterName 단독 dimension으로 동작하지 않는다.
# Container Insights 활성화 + ClusterName/Namespace/PodName 조합이 필요하다.
# 현재는 Prometheus + AlertManager 기반 감지로 대체한다.
#
# Prometheus alert 예시:
#   alert: PodCrashLooping
#   expr: rate(kube_pod_container_status_restarts_total[5m]) * 60 > 0
#   for: 5m
#   labels:
#     severity: warning