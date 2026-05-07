output "github_oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.github.arn
}

output "github_actions_role_arns" {
  value = {
    for repo, role in aws_iam_role.github_actions :
    repo => role.arn
  }
}

output "ecr_push_policy_arn" {
  value = aws_iam_policy.ecr_push.arn
}

output "terraform_state_policy_arn" {
  value = aws_iam_policy.terraform_state.arn
}

output "terraform_infra_policy_arn" {
  value = aws_iam_policy.terraform_infra.arn
}

output "argocd_eks_policy_arn" {
  value = var.enable_argocd_eks_policy ? aws_iam_policy.argocd_eks[0].arn : null
}