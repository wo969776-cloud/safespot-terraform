locals {
  repo_branch_subjects = flatten([
    for repo in var.github_repos : [
      for branch in var.allowed_branches :
      "repo:${var.github_org}/${repo}:ref:refs/heads/${branch}"
    ]
  ])
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-github-oidc"
  })
}

resource "aws_iam_role" "github_actions" {
  for_each = toset(var.github_repos)

  name = "${local.name_prefix}-${each.value}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              for branch in var.allowed_branches :
              "repo:${var.github_org}/${each.value}:ref:refs/heads/${branch}"
            ]
          }
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-${each.value}-role"
  })
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

resource "aws_iam_role_policy_attachment" "argocd_eks" {
  for_each = var.enable_argocd_eks_policy ? aws_iam_role.github_actions : {}

  role       = each.value.name
  policy_arn = aws_iam_policy.argocd_eks[0].arn
}