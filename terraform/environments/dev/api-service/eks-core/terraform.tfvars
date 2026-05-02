env = "dev"

cluster_name    = "safespot-dev-eks"
cluster_version = "1.34"

vpc_id = "vpc-xxxxxxxxxxxxxxxxx"

private_subnet_ids = [
  "subnet-aaaaaaaaaaaaaaaaa",
  "subnet-bbbbbbbbbbbbbbbbb"
]

control_plane_subnet_ids = [
  "subnet-aaaaaaaaaaaaaaaaa",
  "subnet-bbbbbbbbbbbbbbbbb"
]

cluster_endpoint_public_access = true

node_instance_types = ["t3.medium"]

node_min_size     = 1
node_max_size     = 3
node_desired_size = 1
