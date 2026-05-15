aws_region = "ap-northeast-2"
project    = "safespot"
env        = "dev"

remote_state_bucket = "safespot-terraform-state"
eks_core_state_key  = "environments/dev/api-service/eks-core/terraform.tfstate"

argocd_namespace     = "argocd"
argocd_chart_version = "7.6.12"

repo_url        = "https://github.com/project-safespot/safespot-terraform.git"
target_revision = "infra/api-service"
addons_path     = "argocd"
