env     = "dev"
project = "safespot"

remote_state_bucket = "safespot-terraform-state"
eks_core_state_key  = "environments/dev/api-service/eks-core/terraform.tfstate"

alb_controller_namespace            = "kube-system"
alb_controller_service_account_name = "aws-load-balancer-controller"
