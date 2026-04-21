# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project}-${var.environment}-data-aurora-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-data-aurora-subnet-group"
  })
}

# Aurora Cluster Parameter Group
resource "aws_rds_cluster_parameter_group" "main" {
  name   = "${var.project}-${var.environment}-data-aurora-cluster-pg"
  family = "aurora-postgresql15"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-data-aurora-cluster-pg"
  })
}

# Aurora Instance Parameter Group
resource "aws_db_parameter_group" "main" {
  name   = "${var.project}-${var.environment}-data-aurora-instance-pg"
  family = "aurora-postgresql15"

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-data-aurora-instance-pg"
  })
}

# Aurora Cluster (Multi-AZ Active/Standby)
resource "aws_rds_cluster" "main" {
  cluster_identifier = "${var.project}-${var.environment}-data-aurora-cluster"

  engine         = "aurora-postgresql"
  engine_version = var.engine_version

  database_name   = var.db_name
  master_username = var.db_username
  master_password = var.db_password
  port            = 5432

  db_subnet_group_name            = aws_db_subnet_group.main.name
  vpc_security_group_ids          = [var.rds_sg_id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.main.name

  storage_encrypted  = true
  availability_zones = var.availability_zones

  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = "03:00-04:00"
  preferred_maintenance_window = "Mon:04:00-Mon:05:00"

  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = "${var.project}-${var.environment}-data-aurora-final-snapshot"

  enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-data-aurora-cluster"
  })
}

# Aurora Instances (writer 1 + reader N)
resource "aws_rds_cluster_instance" "main" {
  count = var.instance_count

  identifier         = "${var.project}-${var.environment}-data-aurora-${count.index == 0 ? "writer" : "reader-${count.index}"}"
  cluster_identifier = aws_rds_cluster.main.id

  engine         = aws_rds_cluster.main.engine
  engine_version = aws_rds_cluster.main.engine_version
  instance_class = var.instance_class

  db_parameter_group_name = aws_db_parameter_group.main.name
  db_subnet_group_name    = aws_db_subnet_group.main.name

  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]

  performance_insights_enabled = true
  monitoring_interval          = 60
  monitoring_role_arn          = aws_iam_role.rds_monitoring.arn

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-data-aurora-${count.index == 0 ? "writer" : "reader-${count.index}"}"
    Role = count.index == 0 ? "writer" : "reader"
  })
}

# Enhanced Monitoring IAM Role
resource "aws_iam_role" "rds_monitoring" {
  name = "${var.project}-${var.environment}-data-aurora-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "monitoring.rds.amazonaws.com" }
    }]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}