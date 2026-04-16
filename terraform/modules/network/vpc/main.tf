# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-vpc-main"
  })
}

# Public 서브넷
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-subnet-public-${substr(var.availability_zones[count.index], -2, 2)}"
    "kubernetes.io/role/elb" = "1"
  })
}

# Private 서브넷
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-subnet-private-${substr(var.availability_zones[count.index], -2, 2)}"
    "kubernetes.io/role/internal-elb"                            = "1"
    "kubernetes.io/cluster/${var.project}-${var.environment}"    = "owned"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-igw-main"
  })
}

# Elastic IP (NAT Gateway용)
# resource "aws_eip" "nat" {
#   count  = length(var.public_subnet_cidrs)
#   domain = "vpc"

#   tags = merge(var.common_tags, {
#     Name = "${var.project}-${var.environment}-network-eip-nat-${substr(var.availability_zones[count.index], -2, 2)}"
#   })
# }

# NAT Gateway
# resource "aws_nat_gateway" "main" {
#   count         = length(var.public_subnet_cidrs)
#   allocation_id = aws_eip.nat[count.index].id
#   subnet_id     = aws_subnet.public[count.index].id

#   tags = merge(var.common_tags, {
#     Name = "${var.project}-${var.environment}-network-natgw-${substr(var.availability_zones[count.index], -2, 2)}"
#   })

#   depends_on = [aws_internet_gateway.main]
# }

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-rt-public"
  })
}

# Private Route Table
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.main[count.index].id
#   }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-network-rt-private-${substr(var.availability_zones[count.index], -2, 2)}"
  })
}

# Public Route Table Association
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Route Table Association
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}