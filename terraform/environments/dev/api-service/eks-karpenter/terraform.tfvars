env     = "dev"
project = "safespot"

remote_state_bucket = "safespot-terraform-state"
eks_core_state_key  = "environments/dev/api-service/eks-core/terraform.tfstate"

karpenter_namespace            = "kube-system"
karpenter_service_account_name = "karpenter"

enable_spot_termination = true
