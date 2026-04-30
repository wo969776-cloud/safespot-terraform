data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "safespot-terraform-state"
    key    = "environments/dev/network/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

module "rds" {
  source = "../../../modules/data/rds-postgresql"

  project     = var.project
  environment = var.environment

  private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids
  rds_sg_id          = data.terraform_remote_state.network.outputs.rds_sg_id
  availability_zones = var.availability_zones

  engine_version = var.rds_engine_version
  instance_class = var.rds_instance_class
  instance_count = var.rds_instance_count

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  backup_retention_period = var.rds_backup_retention_period
  deletion_protection     = var.rds_deletion_protection
  skip_final_snapshot     = var.rds_skip_final_snapshot

  common_tags = local.common_tags
}

module "redis" {
  source = "../../../modules/data/redis"

  project     = var.project
  environment = var.environment

  private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids
  redis_sg_id        = data.terraform_remote_state.network.outputs.redis_sg_id

  engine_version           = var.redis_engine_version
  node_type                = var.redis_node_type
  num_cache_clusters       = var.redis_num_cache_clusters
  snapshot_retention_limit = var.redis_snapshot_retention_limit

  common_tags = local.common_tags
}