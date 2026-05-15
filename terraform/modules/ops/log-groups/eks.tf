# modules/ops/log-groups/eks.tf
#
# monitoring.md 섹션 1:
#   ALB/EKS metric → CloudWatch / Prometheus / Container Insights
#   Application log → Fluent Bit → CloudWatch Logs
#
# EKS Log Group 두 가지:
#   1. control plane log  : /aws/eks/{cluster_name}/cluster (AWS 고정 형식)
#   2. application log    : /safespot/{env}/{service}       (Fluent Bit 전송 대상)
#
# control plane log는 EKS 클러스터 설정에서 활성화해야 수집된다.
# TODO: compute 파트 EKS 클러스터 리소스에서
#       enabled_cluster_log_types = var.eks_log_types 로 설정할 것.
#       이 Log Group을 먼저 생성해두지 않으면 EKS가 자동으로 생성하므로
#       보존 기간 설정이 적용되지 않는다.
#       → 이 모듈을 compute 파트보다 먼저 apply하거나
#         compute apply 직후 이 모듈을 apply해서 보존 기간을 덮어씌울 것.

# ── EKS Control Plane Log Group ───────────────────────────────────────────────

resource "aws_cloudwatch_log_group" "eks_control_plane" {
  # AWS 고정 형식: /aws/eks/{cluster_name}/cluster
  name              = local.eks_control_plane_log_group_name
  retention_in_days = var.eks_control_plane_retention_days
  kms_key_id        = local.kms_key_arn

  tags = {
    Name      = local.eks_control_plane_log_group_name
    LogType   = "eks-control-plane"
    Component = "eks"
  }
}

# ── EKS Control Plane Log Type별 참고 ────────────────────────────────────────
# 아래 local은 compute 파트에서 EKS 클러스터 설정 시 참고용으로 출력한다.
# 실제 log type 활성화는 compute 파트 EKS 리소스에서 수행한다.

locals {
  # TODO: compute 파트 aws_eks_cluster 리소스에 아래 값을 전달할 것
  #
  # resource "aws_eks_cluster" "main" {
  #   ...
  #   enabled_cluster_log_types = [
  #     "api", "audit", "authenticator", "controllerManager", "scheduler"
  #   ]
  # }
  #
  # 각 log type의 역할:
  #   api               : API server 요청/응답. kubectl 명령 추적 가능
  #   audit             : 보안 감사 로그. 누가 무엇을 했는지 기록
  #   authenticator     : aws-auth ConfigMap 기반 인증 로그
  #   controllerManager : Deployment, ReplicaSet 등 컨트롤러 동작
  #   scheduler         : Pod 스케줄링 결정 로그
  eks_log_types_reference = var.eks_log_types
}

# ── Application Log Group (Fluent Bit 전송 대상) ──────────────────────────────
# monitoring.md: Application log → stdout JSON log → Fluent Bit → CloudWatch Logs
#
# Fluent Bit이 각 서비스 Pod의 stdout을 수집해서
# 이 Log Group으로 전송한다.
# TODO: observability-iam/fluentbit-irsa.tf 에서 생성한 IRSA Role이
#       이 Log Group에 write 권한을 가져야 한다.
#       fluentbit-irsa.tf의 IAM Policy Resource에
#       아래 Log Group ARN을 포함시킬 것.

resource "aws_cloudwatch_log_group" "application" {
  for_each = local.app_log_group_names

  name              = each.value
  retention_in_days = var.retention_days
  kms_key_id        = local.kms_key_arn

  tags = {
    Name      = each.value
    Service   = each.key
    LogType   = "application"
    Component = "fluent-bit"
  }
}

# ── Container Insights Log Group ──────────────────────────────────────────────
# Container Insights가 활성화되면 AWS가 자동으로 생성하는 Log Group.
# 보존 기간을 제어하려면 미리 생성해둬야 한다.
#
# TODO: Container Insights 활성화 여부에 따라 아래 Log Group이 필요한지 확인할 것.
#       compute 파트에서 amazon-cloudwatch-observability 애드온을 배포하면
#       /aws/containerinsights/{cluster_name}/performance 가 자동 생성된다.
#       보존 기간 제어가 필요하면 아래 주석을 해제할 것.

# resource "aws_cloudwatch_log_group" "container_insights" {
#   name              = "/aws/containerinsights/${var.eks_cluster_name}/performance"
#   retention_in_days = var.retention_days
#   kms_key_id        = local.kms_key_arn
#
#   tags = {
#     Name      = "/aws/containerinsights/${var.eks_cluster_name}/performance"
#     LogType   = "container-insights"
#     Component = "eks"
#   }
# }