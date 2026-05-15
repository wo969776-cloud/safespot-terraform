# modules/ops/cicd/github-oidc.tf

resource "aws_iam_openid_connect_provider" "github" {
  url = local.github_oidc_url

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "7560d6f40fa55195f740ee2b1b7c0b4836cbe103"
  ]

  tags = merge(var.common_tags, {
    Name    = "${local.name_prefix}-iam-oidc-github"
    Service = "github-actions"
  })
}