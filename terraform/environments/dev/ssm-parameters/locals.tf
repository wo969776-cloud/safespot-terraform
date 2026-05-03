locals {
  domain = "ssm-parameters"

  common_tags = {
    Project     = var.project
    Environment = var.env
    Domain      = local.domain
    ManagedBy   = "terraform"
    Service     = var.project
    CostCenter  = "${var.project}-${var.env}"
  }

  remote_state_parameters = {
    "data/aurora-cluster-endpoint" = {
      value       = data.terraform_remote_state.data.outputs.aurora_cluster_endpoint
      type        = "String"
      description = "Aurora writer endpoint from data remote state"
    }

    "data/aurora-reader-endpoint" = {
      value       = data.terraform_remote_state.data.outputs.aurora_reader_endpoint
      type        = "String"
      description = "Aurora reader endpoint from data remote state"
    }

    "data/aurora-port" = {
      value       = tostring(data.terraform_remote_state.data.outputs.aurora_port)
      type        = "String"
      description = "Aurora port from data remote state"
    }

    "data/aurora-db-name" = {
      value       = data.terraform_remote_state.data.outputs.aurora_db_name
      type        = "String"
      description = "Aurora database name from data remote state"
    }

    "data/redis-primary-endpoint" = {
      value       = data.terraform_remote_state.data.outputs.redis_primary_endpoint
      type        = "String"
      description = "Redis primary endpoint from data remote state"
    }

    "data/redis-reader-endpoint" = {
      value       = data.terraform_remote_state.data.outputs.redis_reader_endpoint
      type        = "String"
      description = "Redis reader endpoint from data remote state"
    }

    "data/redis-port" = {
      value       = tostring(data.terraform_remote_state.data.outputs.redis_port)
      type        = "String"
      description = "Redis port from data remote state"
    }
  }
}
