project = "safespot"
env     = "dev"

remote_state_bucket = "safespot-terraform-state"
network_state_key   = "environments/dev/network/terraform.tfstate"

cluster_name    = "safespot-dev-eks"
cluster_version = "1.34"

cluster_endpoint_public_access  = true
cluster_endpoint_private_access = true

# Phase 1 bootstrap: keep false until eks-sg-rules has been applied.
# Phase 3: change to true and re-apply eks-core to create the managed node groups.
create_managed_node_group = false

managed_node_groups = {
  system = {
    name           = "safespot-dev-mng-system"
    instance_types = ["t3.medium"]
    iam_role_name  = "safespot-dev-mng-role-system"
    min_size       = 1
    desired_size   = 1
    max_size       = 2
    taints = [
      {
        key    = "safespot.io/dedicated"
        value  = "system"
        effect = "NO_SCHEDULE"
      }
    ]
  }

  ops = {
    name           = "safespot-dev-mng-ops"
    instance_types = ["t3.large"]
    iam_role_name  = "safespot-dev-mng-role-ops"
    min_size       = 1
    desired_size   = 1
    max_size       = 2
    taints = [
      {
        key    = "safespot.io/dedicated"
        value  = "ops"
        effect = "NO_SCHEDULE"
      }
    ]
  }

  app = {
    name           = "safespot-dev-mng-app"
    instance_types = ["t3.large"]
    iam_role_name  = "safespot-dev-mng-role-app"
    min_size       = 1
    desired_size   = 2
    max_size       = 3
  }
}
