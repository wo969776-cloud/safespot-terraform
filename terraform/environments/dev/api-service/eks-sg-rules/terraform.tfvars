aws_region = "ap-northeast-2"
project    = "safespot"
env        = "dev"

remote_state_bucket = "safespot-terraform-state"
network_state_key   = "environments/dev/network/terraform.tfstate"
eks_core_state_key  = "environments/dev/api-service/eks-core/terraform.tfstate"

app_port = 8080

# These are already owned by terraform/modules/network/sg in the current branch.
enable_alb_app_ingress        = false
enable_alb_nodeport_ingress   = false
enable_node_https_to_internet = false
