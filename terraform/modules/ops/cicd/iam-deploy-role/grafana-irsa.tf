# modules/ops/observability-iam/grafana-irsa.tf
#
# monitoring.md 섹션 1:
#   Dashboard / alert → Grafana + AlertManager, CloudWatch Alarm 병행
#
# Grafana Pod가 CloudWatch를 datasource로 직접 조회할 때 필요한 IRSA Role.
#
# enable_grafana_irsa = false (기본값):
#   Grafana가 Prometheus만 datasource로 사용하면 이 Role은 불필요.
#   Grafana → CloudWatch 직접 연동 시 true로 변경.
#   TODO: observability chart 설계 확정 후 결정할 것.

resource "aws_iam_role" "grafana" {
  count = var.enable_grafana_irsa ? 1 : 0

  name        = "${local.name_prefix}-grafana-irsa"
  description = "Grafana CloudWatch datasource IRSA Role"

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
            "${local.oidc_provider_url_stripped}:aud" = "sts.amazonaws.com"
            # sub: Grafana ServiceAccount만 이 Role을 assume할 수 있도록 제한
            "${local.oidc_provider_url_stripped}:sub" = local.grafana_sa_sub
          }
        }
      }
    ]
  })

  tags = {
    Name      = "${local.name_prefix}-grafana-irsa"
    Component = "grafana"
    # TODO: observability Helm chart 배포 시
    #       grafana ServiceAccount에 아래 annotation을 추가해야 IRSA가 동작함
    #       eks.amazonaws.com/role-arn: <이 Role의 ARN>
    Purpose = "cloudwatch-datasource"
  }
}

# ── CloudWatch 읽기 권한 attach ───────────────────────────────────────────────
# cloudwatch-read.tf 에서 정의한 공통 읽기 Policy를 attach

resource "aws_iam_role_policy_attachment" "grafana_cloudwatch_read" {
  count = var.enable_grafana_irsa ? 1 : 0

  role       = aws_iam_role.grafana[0].name
  policy_arn = aws_iam_policy.cloudwatch_read.arn
}

# ── Grafana ServiceAccount annotation 가이드 ──────────────────────────────────
# TODO: observability Helm chart values.yaml에 아래 내용을 추가할 것
#
# kube-prometheus-stack 또는 grafana standalone 기준:
#
# grafana:
#   serviceAccount:
#     name: grafana              # var.grafana_service_account_name 과 일치
#     annotations:
#       eks.amazonaws.com/role-arn: <grafana IRSA Role ARN>
#
#   # Grafana CloudWatch datasource 자동 설정
#   additionalDataSources:
#     - name: CloudWatch
#       type: cloudwatch
#       jsonData:
#         authType: default      # IRSA 사용 시 default (EC2 instance profile 방식)
#         defaultRegion: ap-northeast-2
#
# 확인 명령:
#   kubectl describe sa grafana -n monitoring
#   → Annotations: eks.amazonaws.com/role-arn: arn:aws:iam::...
#
# TODO: Grafana CloudWatch datasource를 사용하면
#       cloudwatch-read.tf 의 권한 범위가 충분한지 확인할 것.
#       특히 logs:StartQuery, logs:GetQueryResults 는
#       Grafana Logs 패널에서 CloudWatch Logs Insights 사용 시 필요.