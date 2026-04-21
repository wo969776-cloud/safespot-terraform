# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.project}-${var.environment}-data-redis-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-data-redis-subnet-group"
  })
}

# ElastiCache Parameter Group
resource "aws_elasticache_parameter_group" "main" {
  name   = "${var.project}-${var.environment}-data-redis-params"
  family = "redis7"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-data-redis-params"
  })
}

# ElastiCache Replication Group (master 1 + replica 4 = 총 5대)
resource "aws_elasticache_replication_group" "main" {
  replication_group_id = "${var.project}-${var.environment}-data-redis-main"
  description          = "Redis master 1 + replica 4 / auto failover for ${var.project} ${var.environment}"

  engine_version = var.engine_version
  node_type      = var.node_type
  port           = 6379

  num_cache_clusters = var.num_cache_clusters

  parameter_group_name = aws_elasticache_parameter_group.main.name
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [var.redis_sg_id]

  automatic_failover_enabled = true
  multi_az_enabled           = true

  at_rest_encryption_enabled = true
  transit_encryption_enabled = false

  snapshot_retention_limit = var.snapshot_retention_limit
  snapshot_window          = "04:00-05:00"
  maintenance_window       = "Mon:05:00-Mon:06:00"

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-data-redis-main"
  })
}