project = "safespot"
env     = "dev"

remote_state_bucket = "safespot-terraform-state"
network_state_key   = "environments/dev/network/terraform.tfstate"

cluster_name    = "safespot-dev-eks"
cluster_version = "1.34"

cluster_endpoint_public_access = true

node_instance_types = ["t3.medium"]

node_min_size     = 1
node_max_size     = 3
node_desired_size = 1
