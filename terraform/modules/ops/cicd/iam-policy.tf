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
          "ecr:GetDownloadUrlForLayer",
          "ecr:DescribeRepositories",
          "ecr:DescribeImages",
        ]
        Resource = values(var.ecr_repository_arns)
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
    Statement = concat(
      [
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
            "arn:aws:iam::${local.account_id}:oidc-provider/token.actions.githubusercontent.com"
          ]
        },
        {
          Sid    = "AllowSSMParameterStore"
          Effect = "Allow"
          Action = [
            "ssm:PutParameter",
            "ssm:GetParameter",
            "ssm:GetParameters",
            "ssm:GetParametersByPath",
            "ssm:DeleteParameter",
            "ssm:DescribeParameters",
            "ssm:AddTagsToResource",
            "ssm:RemoveTagsFromResource"
          ]
          Resource = [
            "arn:aws:ssm:*:${local.account_id}:parameter/${var.project}/${var.environment}/*"
          ]
        }
      ],
      var.ssm_kms_key_arn != "" ? [
        {
          Sid    = "AllowKMSForSecureString"
          Effect = "Allow"
          Action = [
            "kms:Decrypt",
            "kms:Encrypt",
            "kms:GenerateDataKey",
            "kms:DescribeKey"
          ]
          Resource = var.ssm_kms_key_arn
        }
      ] : [],
      [
        {
          Sid      = "AllowSTSGetCallerIdentity"
          Effect   = "Allow"
          Action   = "sts:GetCallerIdentity"
          Resource = "*"
        }
      ]
    )
  })


  tags = merge(var.common_tags, {
    Name    = "${local.name_prefix}-iam-policy-terraform-infra"
    Service = "terraform"
  })
}

# ECR push: application/container build repo만
resource "aws_iam_role_policy_attachment" "ecr_push" {
  for_each = toset([
    for repo in var.ecr_push_repos : "${var.github_org}/${repo}"
  ])

  role       = aws_iam_role.github_actions[each.key].name
  policy_arn = aws_iam_policy.ecr_push.arn
}

# Terraform state: terraform repo만
resource "aws_iam_role_policy_attachment" "terraform_state" {
  for_each = toset([
    for repo in var.terraform_repos : "${var.github_org}/${repo}"
  ])

  role       = aws_iam_role.github_actions[each.key].name
  policy_arn = aws_iam_policy.terraform_state.arn
}

# Terraform infra apply: terraform repo + enable_terraform_apply 플래그
resource "aws_iam_role_policy_attachment" "terraform_infra" {
  for_each = var.enable_terraform_apply ? toset([
    for repo in var.terraform_repos : "${var.github_org}/${repo}"
  ]) : toset([])

  role       = aws_iam_role.github_actions[each.key].name
  policy_arn = aws_iam_policy.terraform_infra[0].arn
}

resource "aws_iam_policy" "frontend_deploy" {
  count = var.frontend_s3_bucket != "" ? 1 : 0
  name  = "${local.name_prefix}-iam-policy-frontend-deploy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "S3FrontendDeploy"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = "arn:aws:s3:::${var.frontend_s3_bucket}"
      },
      {
        Sid      = "S3FrontendObjectDeploy"
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:DeleteObject"]
        Resource = "arn:aws:s3:::${var.frontend_s3_bucket}/*"
      },
      {
        Sid      = "CloudFrontInvalidation"
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

# Frontend deploy: front repo만
resource "aws_iam_role_policy_attachment" "frontend_deploy" {
  for_each = var.frontend_s3_bucket != "" ? toset([
    for repo in var.frontend_deploy_repos : "${var.github_org}/${repo}"
  ]) : toset([])

  role       = aws_iam_role.github_actions[each.key].name
  policy_arn = aws_iam_policy.frontend_deploy[0].arn
}
