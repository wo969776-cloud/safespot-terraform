locals {
  effective_control_plane_subnet_ids = (
    length(var.control_plane_subnet_ids) > 0
    ? var.control_plane_subnet_ids
    : var.private_subnet_ids
  )

  before_compute_cluster_addons = {
    vpc-cni = {
      most_recent    = true
      before_compute = true
    }
  }

  after_compute_cluster_addons = {
    coredns = {
      most_recent = true
    }

    kube-proxy = {
      most_recent = true
    }

    eks-pod-identity-agent = {
      most_recent = true
    }
  }

  cluster_addons = merge(
    local.before_compute_cluster_addons,
    var.create_managed_node_group ? local.after_compute_cluster_addons : {}
  )
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnet_ids
  control_plane_subnet_ids = local.effective_control_plane_subnet_ids

  create_cluster_security_group = true

  create_node_security_group = false
  node_security_group_id     = var.node_security_group_id

  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access

  enable_cluster_creator_admin_permissions = true

  bootstrap_self_managed_addons = false

  cluster_addons = local.cluster_addons

  eks_managed_node_groups = var.create_managed_node_group ? {
    for k, v in var.managed_node_groups : k => {
      name = v.name

      iam_role_name            = v.iam_role_name
      iam_role_use_name_prefix = false

      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = v.instance_types

      min_size     = v.min_size
      max_size     = v.max_size
      desired_size = v.desired_size

      labels = merge(
        {
          # role 레이블은 과도기 호환용 — manifest/addon values가 safespot.io/* 레이블로 모두 전환된 후 제거
          role                         = k
          "safespot.io/node-group"     = k
          "safespot.io/workload-class" = k
        },
        v.labels
      )

      taints = v.taints

      tags = merge(var.tags, {
        Name          = "${var.cluster_name}-${k}"
        NodeGroup     = k
        WorkloadClass = k
      })
    }
  } : {}

  tags = var.tags
}
