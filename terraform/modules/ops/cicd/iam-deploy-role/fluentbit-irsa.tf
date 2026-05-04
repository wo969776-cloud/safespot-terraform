# modules/ops/observability-iam/fluentbit-irsa.tf
#
# monitoring.md 섹션 1:
#   Application log → stdout JSON log → Fluent Bit → CloudWatch Logs
#
# Fluent Bit Pod가 CloudWatch Logs에 로그를 write하려면 IAM 권한이 필요.
# IRSA 방식으로 ServiceAccount에 권한을 부여한다.
#
# enable_fluentbit_irsa = false (기본값):
#   Fluent Bit 배포 계획 확정 후 true로 변경.

resource "aws_iam_role" "fluentbit" {
  count = var.enable_fluentbit_irsa ? 1 : 0

  name        = "${local.name_prefix}-fluentbit-irsa"
  description = "Fluent Bit CloudWatch Logs write IRSA Role"

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
            # sub: Fluent Bit ServiceAccount만 이 Role을 assume할 수 있도록 제한
            "${local.oidc_provider_url_stripped}:sub" = local.fluentbit_sa_sub
          }
        }
      }
    ]
  })

  tags = {
    Name      = "${local.name_prefix}-fluentbit-irsa"
    Component = "fluent-bit"
    # TODO: logging Helm chart 배포 시
    #       fluent-bit ServiceAccount에 아래 annotation을 추가해야 IRSA가 동작함
    #       eks.amazonaws.com/role-arn: <이 Role의 ARN>
    Purpose = "cloudwatch-logs-write"
  }
}

# ── Fluent Bit CloudWatch Logs write 전용 Policy ──────────────────────────────
# cloudwatch-read.tf 의 읽기 Policy와 분리해서 최소 권한 원칙 적용
# Fluent Bit은 로그 write만 필요하고 read 권한은 불필요

resource "aws_iam_policy" "fluentbit_cloudwatch_write" {
  count = var.enable_fluentbit_irsa ? 1 : 0

  name        = "${local.name_prefix}-fluentbit-cloudwatch-write"
  description = "Fluent Bit CloudWatch Logs write 전용 최소 권한 정책"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # ── Log Group 생성 ────────────────────────────────────────────────────
      # Fluent Bit이 Log Group이 없을 때 자동 생성하는 경우 필요
      # log-groups 모듈로 미리 생성해두면 이 권한은 불필요할 수 있음
      # TODO: log-groups 모듈로 모든 Log Group을 미리 생성한다면
      #       CreateLogGroup을 제거해서 권한을 더 좁힐 수 있음
      {
        Sid    = "AllowLogGroupCreate"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
        ]
        Resource = local.fluentbit_log_group_arns
      },

      # ── Log Stream 생성 및 로그 write ─────────────────────────────────────
      {
        Sid    = "AllowLogStreamWrite"
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
        ]
        # Log Group ARN에 :* 를 추가해야 Log Stream ARN까지 커버됨
        Resource = [
          for arn in local.fluentbit_log_group_arns :
          "${arn}:*"
        ]
      },

      # ── Log Group 목록 조회 ───────────────────────────────────────────────
      # Fluent Bit이 Log Group 존재 여부를 확인할 때 필요
      {
        Sid    = "AllowLogGroupDescribe"
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
        ]
        Resource = "*"
        # TODO: Resource를 특정 Log Group ARN으로 제한하면
        #       더 좁은 권한을 부여할 수 있음
        #       단 DescribeLogGroups는 특정 리소스 ARN 지정이 제한적이므로
        #       와일드카드를 허용하는 경우가 일반적
      },
    ]
  })

  tags = {
    Name      = "${local.name_prefix}-fluentbit-cloudwatch-write"
    Component = "fluent-bit"
    Purpose   = "cloudwatch-logs-write-only"
  }
}

# ── Policy attach ─────────────────────────────────────────────────────────────

resource "aws_iam_role_policy_attachment" "fluentbit_cloudwatch_write" {
  count = var.enable_fluentbit_irsa ? 1 : 0

  role       = aws_iam_role.fluentbit[0].name
  policy_arn = aws_iam_policy.fluentbit_cloudwatch_write[0].arn
}

# ── Fluent Bit ServiceAccount annotation 가이드 ───────────────────────────────
# TODO: logging Helm chart values.yaml에 아래 내용을 추가할 것
#
# fluent-bit 기준:
#
# serviceAccount:
#   name: fluent-bit             # var.fluentbit_service_account_name 과 일치
#   annotations:
#     eks.amazonaws.com/role-arn: <fluentbit IRSA Role ARN>
#
# Fluent Bit output 설정 (CloudWatch Logs):
#   [OUTPUT]
#     Name              cloudwatch_logs
#     Match             *
#     region            ap-northeast-2
#     log_group_name    /safespot/dev/api-core
#     log_stream_prefix pod-
#     auto_create_group false   # log-groups 모듈로 미리 생성하므로 false 권장
#
# TODO: Helm chart values에서 각 서비스별 log_group_name을
#       log-groups 모듈 output과 일치시킬 것
#       log-groups 모듈의 app_log_group_names output 참조