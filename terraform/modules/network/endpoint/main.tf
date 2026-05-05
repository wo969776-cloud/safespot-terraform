# S3 Gateway Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.ap-northeast-2.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.private_app_route_table_ids

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-vpc-endpoint-s3"
  })
}

# ECR API Interface Endpoint
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-northeast-2.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_app_subnet_ids
  security_group_ids  = [var.eks_node_sg_id]
  private_dns_enabled = true

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-vpc-endpoint-ecr-api"
  })
}

# ECR DKR Interface Endpoint
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-northeast-2.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_app_subnet_ids
  security_group_ids  = [var.eks_node_sg_id]
  private_dns_enabled = true

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-vpc-endpoint-ecr-dkr"
  })
}

# CloudWatch Logs Interface Endpoint
resource "aws_vpc_endpoint" "cloudwatch_logs" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-northeast-2.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_app_subnet_ids
  security_group_ids  = [var.eks_node_sg_id]
  private_dns_enabled = true

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-vpc-endpoint-logs"
  })
}

# STS Interface Endpoint
resource "aws_vpc_endpoint" "sts" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-northeast-2.sts"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_app_subnet_ids
  security_group_ids  = [var.eks_node_sg_id]
  private_dns_enabled = true

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-vpc-endpoint-sts"
  })
}

# SSM Interface Endpoint
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-northeast-2.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_app_subnet_ids
  security_group_ids  = [var.eks_node_sg_id]
  private_dns_enabled = true

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-vpc-endpoint-ssm"
  })
}

# SQS Interface Endpoint
resource "aws_vpc_endpoint" "sqs" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-northeast-2.sqs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_app_subnet_ids
  security_group_ids  = [var.eks_node_sg_id]
  private_dns_enabled = true

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-vpc-endpoint-sqs"
  })
}

# EC2 Interface Endpoint (SSM Session Manager용)
resource "aws_vpc_endpoint" "ec2" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-northeast-2.ec2"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_app_subnet_ids
  security_group_ids  = [var.eks_node_sg_id]
  private_dns_enabled = true
  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-vpc-endpoint-ec2"
  })
}

# SSM Messages Interface Endpoint (SSM Session Manager용)
resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-northeast-2.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_app_subnet_ids
  security_group_ids  = [var.eks_node_sg_id]
  private_dns_enabled = true
  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-vpc-endpoint-ssmmessages"
  })
}

# EC2 Messages Interface Endpoint (SSM Session Manager용)
resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.ap-northeast-2.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_app_subnet_ids
  security_group_ids  = [var.eks_node_sg_id]
  private_dns_enabled = true
  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-vpc-endpoint-ec2messages"
  })
}