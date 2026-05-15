output "github_oidc_provider_arn" {
  value = module.cicd.github_oidc_provider_arn
}

output "github_actions_role_arns" {
  value = module.cicd.github_actions_role_arns
}

output "ecr_push_policy_arn" {
  value = module.cicd.ecr_push_policy_arn
}

output "terraform_state_policy_arn" {
  value = module.cicd.terraform_state_policy_arn
}

output "terraform_infra_policy_arn" {
  value = module.cicd.terraform_infra_policy_arn
}