resource "aws_vpc_security_group_ingress_rule" "node_from_cluster_primary" {
  for_each = var.control_plane_to_node_ports

  security_group_id            = var.node_security_group_id
  referenced_security_group_id = var.cluster_primary_security_group_id
  ip_protocol                  = "tcp"
  from_port                    = each.value
  to_port                      = each.value
  description                  = "EKS control plane to node ${each.key}"

  tags = merge(var.tags, {
    Name = "eks-node-from-cluster-${each.key}"
  })
}

resource "aws_vpc_security_group_egress_rule" "cluster_primary_to_node" {
  for_each = var.control_plane_to_node_ports

  security_group_id            = var.cluster_primary_security_group_id
  referenced_security_group_id = var.node_security_group_id
  ip_protocol                  = "tcp"
  from_port                    = each.value
  to_port                      = each.value
  description                  = "EKS control plane egress to node ${each.key}"

  tags = merge(var.tags, {
    Name = "eks-cluster-to-node-${each.key}"
  })
}

resource "aws_vpc_security_group_ingress_rule" "cluster_primary_from_node_api" {
  security_group_id            = var.cluster_primary_security_group_id
  referenced_security_group_id = var.node_security_group_id
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
  description                  = "Node to EKS private API endpoint"

  tags = merge(var.tags, {
    Name = "eks-cluster-from-node-api"
  })
}

resource "aws_vpc_security_group_ingress_rule" "cluster_to_nodes_prometheus_adapter" {
  security_group_id            = var.node_security_group_id
  referenced_security_group_id = var.cluster_primary_security_group_id
  ip_protocol                  = "tcp"
  from_port                    = 6443
  to_port                      = 6443
  description                  = "EKS control plane to node Prometheus Adapter"

  tags = merge(var.tags, {
    Name = "eks-cluster-to-node-prometheus-adapter"
  })

}

resource "aws_vpc_security_group_egress_rule" "node_to_cluster_primary_api" {
  security_group_id            = var.node_security_group_id
  referenced_security_group_id = var.cluster_primary_security_group_id
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
  description                  = "Node to EKS private API endpoint"

  tags = merge(var.tags, {
    Name = "eks-node-to-cluster-api"
  })
}

resource "aws_vpc_security_group_egress_rule" "node_to_node_all" {
  security_group_id            = var.node_security_group_id
  referenced_security_group_id = var.node_security_group_id
  ip_protocol                  = "-1"
  description                  = "Node to node and pod to pod egress"

  tags = merge(var.tags, {
    Name = "eks-node-to-node-all"
  })
}

resource "aws_vpc_security_group_egress_rule" "node_to_dns_udp" {
  security_group_id = var.node_security_group_id
  cidr_ipv4         = var.vpc_dns_resolver_cidr
  ip_protocol       = "udp"
  from_port         = 53
  to_port           = 53
  description       = "Node and CoreDNS to VPC DNS resolver UDP"

  tags = merge(var.tags, {
    Name = "eks-node-to-dns-udp"
  })
}

resource "aws_vpc_security_group_egress_rule" "node_to_dns_tcp" {
  security_group_id = var.node_security_group_id
  cidr_ipv4         = var.vpc_dns_resolver_cidr
  ip_protocol       = "tcp"
  from_port         = 53
  to_port           = 53
  description       = "Node and CoreDNS to VPC DNS resolver TCP"

  tags = merge(var.tags, {
    Name = "eks-node-to-dns-tcp"
  })
}

resource "aws_vpc_security_group_egress_rule" "node_to_vpc_endpoint_https" {
  for_each = var.endpoint_security_group_ids

  security_group_id            = var.node_security_group_id
  referenced_security_group_id = each.value
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
  description                  = "Node HTTPS egress to interface VPC endpoint"

  tags = merge(var.tags, {
    Name = "eks-node-to-vpc-endpoint-https"
  })
}

resource "aws_vpc_security_group_egress_rule" "node_to_internet_https" {
  count = var.enable_node_https_to_internet ? 1 : 0

  security_group_id = var.node_security_group_id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  description       = "Node HTTPS egress via NAT for GitHub, Helm repos, and external registries"

  tags = merge(var.tags, {
    Name = "eks-node-to-internet-https"
  })
}

resource "aws_vpc_security_group_ingress_rule" "alb_to_node_app" {
  count = var.alb_security_group_id != null && var.enable_alb_app_ingress ? 1 : 0

  security_group_id            = var.node_security_group_id
  referenced_security_group_id = var.alb_security_group_id
  ip_protocol                  = "tcp"
  from_port                    = var.app_port
  to_port                      = var.app_port
  description                  = "ALB to application target port"

  tags = merge(var.tags, {
    Name = "eks-node-from-alb-app"
  })
}

resource "aws_vpc_security_group_ingress_rule" "alb_to_node_nodeport" {
  count = var.alb_security_group_id != null && var.enable_alb_nodeport_ingress ? 1 : 0

  security_group_id            = var.node_security_group_id
  referenced_security_group_id = var.alb_security_group_id
  ip_protocol                  = "tcp"
  from_port                    = 30000
  to_port                      = 32767
  description                  = "ALB to Kubernetes NodePort range"

  tags = merge(var.tags, {
    Name = "eks-node-from-alb-nodeport"
  })
}
