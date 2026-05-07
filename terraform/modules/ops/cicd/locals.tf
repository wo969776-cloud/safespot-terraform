locals {
  domain    = "ops"
  subdomain = "cicd"

  name_prefix = "${var.project}-${var.environment}-${local.domain}-${local.subdomain}"

  github_oidc_url  = "https://token.actions.githubusercontent.com"
  github_oidc_host = "token.actions.githubusercontent.com"

  account_id = var.account_id

  terraform_state_object_arns = [
    for prefix in var.terraform_state_key_prefixes :
    "arn:aws:s3:::${var.terraform_state_bucket}/${prefix}*"
  ]
}