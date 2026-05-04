# modules/ops/observability-iam/prometheus-irsa.tf
#
# monitoring.md 섹션 1:
#   Application metric → Micrometer → Prometheus
#   Redis infra metric → redis-exporter → Prometheus
#   ALB/EKS metric     → CloudWatch / Prometheus 병행
#
# Prometheus Pod가 AWS API를 호출할 때 필요한 IRSA Role.
# 주로 CloudWatch exporter를 통해 CloudWatch metric을 수집할 때 사용.
#
# enable_prometheus_irsa = false (기본값):
#   Prometheus가 EKS 내부 metric만 수집하는 경우 이 Role은 불필요.
#   CloudWatch exporter 사용 확정 후 true로 변경.

resource "aws_iam_role" "prometheus" {
  count = var.enable_prometheus_irsa ? 1 : 0

  name        = "${local.name_prefix}-prometheus-irsa"
  description = "Prometheus CloudWatch exporter IRSA Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEKSServiceAccountAssume"
        Effect = "Allow"
        Principal = {
          Federated = var.eks_oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            # OIDC audience: EKS IRSA 표준값
            "${local.oidc_provider_url_stripped}:aud" = "sts.amazonaws.com"
            # sub: Prometheus ServiceAccount만 이 Role을 assume할 수 있도록 제한
            "${local.oidc_provider_url_stripped}:sub" = local.prometheus_sa_sub
          }
        }
      }
    ]
  })

  tags = {
    Name      = "${local.name_prefix}-prometheus-irsa"
    Component = "prometheus"
    # TODO: observability Helm chart 배포 시
    #       prometheus ServiceAccount에 아래 annotation을 추가해야 IRSA가 동작함
    #       eks.amazonaws.com/role-arn: <이 Role의 ARN>
    Purpose = "cloudwatch-exporter"
  }
}

# ── CloudWatch 읽기 권한 attach ───────────────────────────────────────────────

resource "aws_iam_role_policy_attachment" "prometheus_cloudwatch_read" {
  count = var.enable_prometheus_irsa ? 1 : 0

  role       = aws_iam_role.prometheus[0].name
  policy_arn = aws_iam_policy.cloudwatch_read.arn
}

# ── Prometheus ServiceAccount annotation 가이드 ───────────────────────────────
# TODO: observability Helm chart values.yaml에 아래 내용을 추가할 것
#
# kube-prometheus-stack 기준:
#
# prometheus:
#   serviceAccount:
#     name: prometheus           # var.prometheus_service_account_name 과 일치
#     annotations:
#       eks.amazonaws.com/role-arn: <prometheus IRSA Role ARN>
#
# 확인 명령:
#   kubectl describe sa prometheus -n monitoring
#   → Annotations: eks.amazonaws.com/role-arn: arn:aws:iam::...