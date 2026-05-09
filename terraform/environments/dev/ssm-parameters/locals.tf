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

  ops_ssm_parameters = {
    "observability/yace/irsa-role-arn" = {
      value       = data.terraform_remote_state.ops.outputs.yace_irsa_role_arn
      type        = "String"
      description = "YACE IRSA Role ARN for CloudWatch metrics read"
    }

    "observability/grafana/irsa-role-arn" = {
      value       = data.terraform_remote_state.ops.outputs.grafana_irsa_role_arn
      type        = "String"
      description = "Grafana IRSA Role ARN for CloudWatch datasource read"
    }
    # fluentbit: enable_fluentbit_irsa = true 활성화 후 아래 항목 추가
    # "observability/fluentbit/irsa-role-arn" = {
    #   value       = data.terraform_remote_state.ops.outputs.fluentbit_irsa_role_arn
    #   type        = "String"
    #   description = "Fluent Bit IRSA Role ARN for CloudWatch Logs write"
    # }
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

    "data/aurora-cluster-identifier" = {
      value       = data.terraform_remote_state.data.outputs.rds_cluster_identifier
      type        = "String"
      description = "Aurora cluster identifier (CloudWatch RDS alarm dimension)"
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

    "data/redis-replication-group-id" = {
      value       = data.terraform_remote_state.data.outputs.redis_cluster_id
      type        = "String"
      description = "ElastiCache replication group ID (CloudWatch Redis alarm dimension)"
    }
  }
}
