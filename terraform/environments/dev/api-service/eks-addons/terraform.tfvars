aws_region  = "ap-northeast-2"
project     = "safespot"
environment = "dev"

remote_state_bucket       = "safespot-terraform-state"
eks_core_state_key        = "environments/dev/api-service/eks-core/terraform.tfstate"
eks_addons_irsa_state_key = "environments/dev/api-service/eks-addons-irsa/terraform.tfstate"
