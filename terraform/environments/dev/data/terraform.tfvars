aws_region  = "ap-northeast-2"
project     = "safespot"
environment = "dev"

# ── Aurora (Active/Standby Multi-AZ) ────────────────────
availability_zones  = ["ap-northeast-2a", "ap-northeast-2c"]
rds_engine_version  = "15.6"
rds_instance_class  = "db.t3.medium"
rds_instance_count  = 2
db_name             = "safespot"
# db_username, db_password → 절대 여기 작성 금지!
# terraform apply -var="db_username=xxx" -var="db_password=yyy"

rds_backup_retention_period = 7
rds_deletion_protection     = false
rds_skip_final_snapshot     = true

# ── Redis (master 1 + replica 4 = 총 5대) ───────────────
redis_engine_version           = "7.1"
redis_node_type                = "cache.t3.micro"
redis_num_cache_clusters       = 5
redis_snapshot_retention_limit = 1