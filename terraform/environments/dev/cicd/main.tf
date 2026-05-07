data "terraform_remote_state" "ops" {
  backend = "s3"

  config = {
    bucket = local.remote_state_bucket
    key    = "environments/${var.environment}/ops/terraform.tfstate"
    region = local.remote_state_region
  }
}

data "terraform_remote_state" "api_service" {
  count   = var.enable_argocd_eks_policy ? 1 : 0
  backend = "s3"

  config = {
    bucket = local.remote_state_bucket
    key    = "environments/${var.environment}/api-service/terraform.tfstate"
    region = local.remote_state_region
  }
}

locals {
  ecr_repository_arns = (
    length(var.ecr_repository_arns) > 0
    ? var.ecr_repository_arns
    : try(data.terraform_remote_state.ops.outputs.ecr_repository_arns, [])
  )

  eks_cluster_name = (
    var.enable_argocd_eks_policy
    ? (
      var.eks_cluster_name != ""
      ? var.eks_cluster_name
      : try(data.terraform_remote_state.api_service[0].outputs.eks_cluster_name, "")
    )
    : ""
  )
}

module "cicd" {
  source = "../../../modules/ops/cicd"

  project     = var.project
  environment = var.environment

  github_org   = var.github_org
  github_repos = var.github_repos

  terraform_state_bucket       = var.terraform_state_bucket
  terraform_state_key_prefixes = local.terraform_state_key_prefixes

  ecr_repository_arns = local.ecr_repository_arns

  enable_argocd_eks_policy = var.enable_argocd_eks_policy
  eks_cluster_name         = local.eks_cluster_name
  account_id = data.aws_caller_identity.current.account_id
}