# modules/ops/cicd/github-oidc.tf

resource "aws_iam_openid_connect_provider" "github" {
  url = local.github_oidc_url

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = []

  tags = merge(var.common_tags, {
    Name    = "${local.name_prefix}-iam-oidc-github"
    Service = "github-actions"
  })
}