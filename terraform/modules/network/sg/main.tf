# ALB Security Group
resource "aws_security_group" "alb" {
  name        = "${var.project}-${var.environment}-network-sg-alb"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-sg-alb"
  })
}

# EKS Node Security Group
resource "aws_security_group" "eks_node" {
  name        = "${var.project}-${var.environment}-network-sg-eks-node"
  description = "EKS Node Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Node to node"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  tags = merge(var.common_tags, {
    Name                                                      = "${var.project}-${var.environment}-network-sg-eks-node"
    "kubernetes.io/cluster/${var.project}-${var.environment}" = "owned"
    "karpenter.sh/discovery"                                  = "${var.project}-${var.environment}-eks"
  })
}

# RDS Security Group
resource "aws_security_group" "rds" {
  name        = "${var.project}-${var.environment}-network-sg-rds"
  description = "RDS Security Group"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-sg-rds"
  })
}

# Redis Security Group
resource "aws_security_group" "redis" {
  name        = "${var.project}-${var.environment}-network-sg-redis"
  description = "Redis Security Group"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-sg-redis"
  })
}

# Lambda Security Group
resource "aws_security_group" "lambda" {
  name        = "${var.project}-${var.environment}-network-sg-lambda"
  description = "Lambda Worker Security Group"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-sg-lambda"
  })
}

# SG Rules — 순환 참조 방지를 위해 별도 분리

resource "aws_security_group_rule" "alb_to_eks_node" {
  type                     = "egress"
  description              = "ALB to EKS node"
  from_port                = var.app_port
  to_port                  = var.app_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = aws_security_group.eks_node.id
}

resource "aws_security_group_rule" "eks_node_from_alb" {
  type                     = "ingress"
  description              = "ALB to EKS node"
  from_port                = var.app_port
  to_port                  = var.app_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_node.id
  source_security_group_id = aws_security_group.alb.id
}

# EKS Node egress rules
resource "aws_security_group_rule" "eks_node_to_external_443" {
  type              = "egress"
  description       = "Node to external (NAT Gateway)"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_node.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "eks_node_to_external_8088" {
  type              = "egress"
  description       = "EKS node to external 8088 (test)"
  from_port         = 8088
  to_port           = 8088
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_node.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "eks_node_to_rds" {
  type                     = "egress"
  description              = "EKS node to RDS"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_node.id
  source_security_group_id = aws_security_group.rds.id
}

resource "aws_security_group_rule" "rds_from_eks" {
  type                     = "ingress"
  description              = "EKS node to RDS"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = aws_security_group.eks_node.id
}

resource "aws_security_group_rule" "eks_node_to_redis" {
  type                     = "egress"
  description              = "EKS node to Redis"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_node.id
  source_security_group_id = aws_security_group.redis.id
}

resource "aws_security_group_rule" "redis_from_eks" {
  type                     = "ingress"
  description              = "EKS node to Redis"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.redis.id
  source_security_group_id = aws_security_group.eks_node.id
}

# Lambda egress rules
resource "aws_security_group_rule" "lambda_to_external_443" {
  type              = "egress"
  description       = "Lambda to external (SQS, CloudWatch, Secrets Manager)"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.lambda.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Lambda → RDS
resource "aws_security_group_rule" "lambda_to_rds" {
  type                     = "egress"
  description              = "Lambda to RDS"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.lambda.id
  source_security_group_id = aws_security_group.rds.id
}

resource "aws_security_group_rule" "rds_from_lambda" {
  type                     = "ingress"
  description              = "Lambda to RDS"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = aws_security_group.lambda.id
}

# Lambda → Redis
resource "aws_security_group_rule" "lambda_to_redis" {
  type                     = "egress"
  description              = "Lambda to Redis"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.lambda.id
  source_security_group_id = aws_security_group.redis.id
}

resource "aws_security_group_rule" "redis_from_lambda" {
  type                     = "ingress"
  description              = "Lambda to Redis"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.redis.id
  source_security_group_id = aws_security_group.lambda.id
}