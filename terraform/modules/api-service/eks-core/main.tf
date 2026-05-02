locals {
  effective_control_plane_subnet_ids = (
    length(var.control_plane_subnet_ids) > 0
    ? var.control_plane_subnet_ids
    : var.private_subnet_ids
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

  create_cluster_security_group = false
  cluster_security_group_id     = var.cluster_security_group_id

  create_node_security_group = false
  node_security_group_id     = var.node_security_group_id

  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  enable_cluster_creator_admin_permissions = true

  bootstrap_self_managed_addons = false

  cluster_addons = {
    coredns = {
      most_recent = true
    }

    kube-proxy = {
      most_recent = true
    }

    vpc-cni = {
      most_recent = true
    }

    eks-pod-identity-agent = {
      most_recent = true
    }
  }

  eks_managed_node_group_defaults = {
    ami_type       = "AL2023_x86_64_STANDARD"
    instance_types = var.node_instance_types
  }

  eks_managed_node_groups = {
    default = {
      name = "default"

      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = var.node_instance_types

      min_size     = var.node_min_size
      max_size     = var.node_max_size
      desired_size = var.node_desired_size

      labels = {
        role = "system"
      }

      tags = merge(var.tags, {
        Name         = "${var.cluster_name}-default"
        NodeGroup    = "default"
        WorkloadRole = "system"
      })
    }
  }

  tags = var.tags
}
