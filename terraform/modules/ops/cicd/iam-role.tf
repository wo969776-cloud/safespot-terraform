resource "aws_iam_role" "github_actions" {
  for_each = toset([
    for repo in var.github_repos : "${var.github_org}/${repo}"
  ])

  name        = local.github_repo_role_names[each.key]
  description = "GitHub Actions OIDC Role for ${each.key}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowGitHubActionsOIDC"
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "${local.github_oidc_host}:aud" = "sts.amazonaws.com"
          }

          StringLike = {
            "${local.github_oidc_host}:sub" = concat(
              [
                for branch in var.allowed_branches :
                "repo:${each.key}:ref:refs/heads/${branch}"
              ],
              [
                for environment in var.allowed_github_environments :
                "repo:${each.key}:environment:${environment}"
              ],
              var.allow_pull_request_oidc ? [
                "repo:${each.key}:pull_request"
              ] : []
            )
          }
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name       = local.github_repo_role_names[each.key]
    Service    = "github-actions"
    Repository = each.key
  })
}
