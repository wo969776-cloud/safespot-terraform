data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_policy" "ecr_push" {
  name = "${local.name_prefix}-iam-policy-ecr-push"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowECRLogin"
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        Sid    = "AllowECRPush"
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
        Resource = var.ecr_repository_arns
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name    = "${local.name_prefix}-iam-policy-ecr-push"
    Service = "github-actions"
  })
}

resource "aws_iam_policy" "terraform_state" {
  name = "${local.name_prefix}-iam-policy-terraform-state"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowS3StateBucketList"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = "arn:aws:s3:::${var.terraform_state_bucket}"
      },
      {
        Sid    = "AllowS3StateObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = local.terraform_state_object_arns
      }
    ]
  })


  tags = merge(var.common_tags, {
    Name    = "${local.name_prefix}-iam-policy-terraform-state"
    Service = "terraform-state"
  })
}

resource "aws_iam_policy" "terraform_infra" {
  count = var.enable_terraform_apply ? 1 : 0
  name  = "${local.name_prefix}-iam-policy-terraform-infra"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudWatch"
        Effect = "Allow"
        Action = [
          "cloudwatch:*Alarm*",
          "cloudwatch:*Dashboard*",
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricData",
          "logs:CreateLogGroup",
          "logs:DeleteLogGroup",
          "logs:PutRetentionPolicy",
          "logs:DescribeLogGroups",
          "logs:TagLogGroup",
          "logs:UntagLogGroup"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowSNS"
        Effect = "Allow"
        Action = [
          "sns:CreateTopic",
          "sns:DeleteTopic",
          "sns:GetTopicAttributes",
          "sns:SetTopicAttributes",
          "sns:Subscribe",
          "sns:Unsubscribe",
          "sns:ListSubscriptionsByTopic",
          "sns:TagResource",
          "sns:UntagResource"
        ]
        Resource = "arn:aws:sns:*:${local.account_id}:${local.name_prefix}-sns-*"
      },
      {
        Sid    = "AllowECRManage"
        Effect = "Allow"
        Action = [
          "ecr:CreateRepository",
          "ecr:DeleteRepository",
          "ecr:DescribeRepositories",
          "ecr:PutLifecyclePolicy",
          "ecr:GetLifecyclePolicy",
          "ecr:DeleteLifecyclePolicy",
          "ecr:PutImageTagMutability",
          "ecr:PutImageScanningConfiguration",
          "ecr:TagResource",
          "ecr:UntagResource",
          "ecr:ListTagsForResource"
        ]
        Resource = "arn:aws:ecr:*:${local.account_id}:repository/${var.project}-${var.environment}-${local.domain}-ecr-*"
      },
      {
        Sid    = "AllowIAM"
        Effect = "Allow"
        Action = [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:GetRole",
          "iam:UpdateAssumeRolePolicy",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:CreatePolicy",
          "iam:DeletePolicy",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:CreatePolicyVersion",
          "iam:DeletePolicyVersion",
          "iam:ListPolicyVersions",
          "iam:ListAttachedRolePolicies",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:TagPolicy",
          "iam:UntagPolicy",
          "iam:CreateOpenIDConnectProvider",
          "iam:DeleteOpenIDConnectProvider",
          "iam:GetOpenIDConnectProvider",
          "iam:UpdateOpenIDConnectProviderThumbprint",
          "iam:TagOpenIDConnectProvider",
          "iam:UntagOpenIDConnectProvider"
        ]
        Resource = [
          "arn:aws:iam::${local.account_id}:role/${local.name_prefix}-iam-role-*",
          "arn:aws:iam::${local.account_id}:policy/${local.name_prefix}-iam-policy-*",
          "arn:aws:iam::${local.account_id}:oidc-provider/*"
        ]
      },
      {
        Sid    = "AllowSecretsManager"
        Effect = "Allow"
        Action = [
          "secretsmanager:CreateSecret",
          "secretsmanager:DeleteSecret",
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecret",
          "secretsmanager:TagResource",
          "secretsmanager:UntagResource"
        ]
        Resource = "arn:aws:secretsmanager:*:${local.account_id}:secret:${var.project}/*"
      },
      {
        Sid      = "AllowSTSGetCallerIdentity"
        Effect   = "Allow"
        Action   = "sts:GetCallerIdentity"
        Resource = "*"
      }
    ]
  })


  tags = merge(var.common_tags, {
    Name    = "${local.name_prefix}-iam-policy-terraform-infra"
    Service = "terraform"
  })
}

resource "aws_iam_role_policy_attachment" "argocd_eks" {
  for_each = var.enable_argocd_eks_policy ? aws_iam_role.github_actions : {}

  role       = each.value.name
  policy_arn = aws_iam_policy.argocd_eks[0].arn
}

resource "aws_iam_role_policy_attachment" "ecr_push" {
  for_each = aws_iam_role.github_actions

  role       = each.value.name
  policy_arn = aws_iam_policy.ecr_push.arn
}

resource "aws_iam_role_policy_attachment" "terraform_state" {
  for_each = aws_iam_role.github_actions

  role       = each.value.name
  policy_arn = aws_iam_policy.terraform_state.arn
}

resource "aws_iam_role_policy_attachment" "terraform_infra" {
  for_each = var.enable_terraform_apply ? aws_iam_role.github_actions : {}

  role       = each.value.name
  policy_arn = aws_iam_policy.terraform_infra[0].arn
}

resource "aws_iam_policy" "argocd_eks" {
  count = var.enable_argocd_eks_policy ? 1 : 0

  name = "${local.name_prefix}-iam-policy-argocd-eks"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowDescribeEKS"
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Resource = "*"
      },
      {
        Sid      = "AllowAccessKubernetesApi"
        Effect   = "Allow"
        Action   = "eks:AccessKubernetesApi"
        Resource = "arn:aws:eks:${var.aws_region}:${var.account_id}:cluster/${var.eks_cluster_name}"
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name    = "${local.name_prefix}-iam-policy-argocd-eks"
    Service = "argocd"
  })
}

resource "aws_iam_policy" "frontend_deploy" {
  name = "${local.name_prefix}-iam-policy-frontend-deploy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowS3FrontendSync"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.frontend_s3_bucket}",
          "arn:aws:s3:::${var.frontend_s3_bucket}/*"
        ]
      },
      {
        Sid      = "AllowCloudfrontInvalidation"
        Effect   = "Allow"
        Action   = "cloudfront:CreateInvalidation"
        Resource = "arn:aws:cloudfront::${local.account_id}:distribution/${var.cloudfront_distribution_id}"
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name    = "${local.name_prefix}-iam-policy-frontend-deploy"
    Service = "frontend"
  })
}

resource "aws_iam_role_policy_attachment" "frontend_deploy" {
  for_each = aws_iam_role.github_actions

  role       = each.value.name
  policy_arn = aws_iam_policy.frontend_deploy.arn
}