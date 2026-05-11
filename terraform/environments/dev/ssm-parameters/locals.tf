locals {
  domain = "ssm-parameters"

  common_tags = {
    Project     = var.project
    Environment = var.environment
    Domain      = local.domain
    ManagedBy   = "terraform"
    Service     = var.project
    CostCenter  = "${var.project}-${var.environment}"
  }

  string_parameters = {
    app_profile = {
      name        = "/safespot/${var.environment}/app/profile"
      value       = var.environment
      description = "SafeSpot runtime profile."
    }

    api_core_context_path = {
      name        = "/safespot/${var.environment}/api/core/context-path"
      value       = "/api/core"
      description = "api-core context path."
    }

    api_public_context_path = {
      name        = "/safespot/${var.environment}/api/public/context-path"
      value       = "/api/public"
      description = "api-public context path."
    }

    aurora_cluster_endpoint = {
      name        = "/safespot/${var.environment}/data/aurora-cluster-endpoint"
      value       = data.terraform_remote_state.data.outputs.aurora_cluster_endpoint
      description = "Aurora writer endpoint."
    }

    aurora_reader_endpoint = {
      name        = "/safespot/${var.environment}/data/aurora-reader-endpoint"
      value       = data.terraform_remote_state.data.outputs.aurora_reader_endpoint
      description = "Aurora reader endpoint."
    }

    aurora_port = {
      name        = "/safespot/${var.environment}/data/aurora-port"
      value       = tostring(data.terraform_remote_state.data.outputs.aurora_port)
      description = "Aurora port."
    }

    aurora_db_name = {
      name        = "/safespot/${var.environment}/data/aurora-db-name"
      value       = data.terraform_remote_state.data.outputs.aurora_db_name
      description = "Aurora database name."
    }

    redis_primary_endpoint = {
      name        = "/safespot/${var.environment}/data/redis-primary-endpoint"
      value       = data.terraform_remote_state.data.outputs.redis_primary_endpoint
      description = "Redis primary endpoint."
    }

    redis_reader_endpoint = {
      name        = "/safespot/${var.environment}/data/redis-reader-endpoint"
      value       = data.terraform_remote_state.data.outputs.redis_reader_endpoint
      description = "Redis reader endpoint."
    }

    redis_port = {
      name        = "/safespot/${var.environment}/data/redis-port"
      value       = tostring(data.terraform_remote_state.data.outputs.redis_port)
      description = "Redis port."
    }

    event_queue_url = {
      name        = "/safespot/${var.environment}/async-worker/event-queue-url"
      value       = data.terraform_remote_state.async_worker.outputs.event_queue_url
      description = "Async worker event queue URL."
    }

    cache_refresh_queue_url = {
      name        = "/safespot/${var.environment}/async-worker/cache-refresh-queue-url"
      value       = data.terraform_remote_state.async_worker.outputs.cache_refresh_queue_url
      description = "Async worker cache refresh queue URL."
    }

    readmodel_refresh_queue_url = {
      name        = "/safespot/${var.environment}/async-worker/readmodel-refresh-queue-url"
      value       = data.terraform_remote_state.async_worker.outputs.readmodel_refresh_queue_url
      description = "Async worker read model refresh queue URL."
    }

    environment_cache_refresh_queue_url = {
      name        = "/safespot/${var.environment}/async-worker/environment-cache-refresh-queue-url"
      value       = data.terraform_remote_state.async_worker.outputs.environment_cache_refresh_queue_url
      description = "Async worker environment cache refresh queue URL."
    }

    cache_refresh_dlq_url = {
      name        = "/safespot/${var.environment}/async-worker/cache-refresh-dlq-url"
      value       = data.terraform_remote_state.async_worker.outputs.cache_refresh_dlq_url
      description = "Async worker cache refresh DLQ URL."
    }

    readmodel_refresh_dlq_url = {
      name        = "/safespot/${var.environment}/async-worker/readmodel-refresh-dlq-url"
      value       = data.terraform_remote_state.async_worker.outputs.readmodel_refresh_dlq_url
      description = "Async worker read model refresh DLQ URL."
    }

    environment_cache_refresh_dlq_url = {
      name        = "/safespot/${var.environment}/async-worker/environment-cache-refresh-dlq-url"
      value       = data.terraform_remote_state.async_worker.outputs.environment_cache_refresh_dlq_url
      description = "Async worker environment cache refresh DLQ URL."
    }

    cache_refresh_dlq_name = {
      name        = "/safespot/${var.environment}/async-worker/cache-refresh-dlq-name"
      value       = data.terraform_remote_state.async_worker.outputs.cache_refresh_dlq_name
      description = "Async worker cache refresh DLQ name."
    }

    readmodel_refresh_dlq_name = {
      name        = "/safespot/${var.environment}/async-worker/readmodel-refresh-dlq-name"
      value       = data.terraform_remote_state.async_worker.outputs.readmodel_refresh_dlq_name
      description = "Async worker read model refresh DLQ name."
    }

    environment_cache_refresh_dlq_name = {
      name        = "/safespot/${var.environment}/async-worker/environment-cache-refresh-dlq-name"
      value       = data.terraform_remote_state.async_worker.outputs.environment_cache_refresh_dlq_name
      description = "Async worker environment cache refresh DLQ name."
    }

    event_dlq_url = {
      name        = "/safespot/${var.environment}/async-worker/event-dlq-url"
      value       = data.terraform_remote_state.async_worker.outputs.cache_refresh_dlq_url
      description = "Async worker event DLQ URL (backward compat alias for cache-refresh-dlq-url)."
    }

    event_dlq_name = {
      name        = "/safespot/${var.environment}/async-worker/event-dlq-name"
      value       = data.terraform_remote_state.async_worker.outputs.cache_refresh_dlq_name
      description = "Async worker event DLQ name (backward compat alias for cache-refresh-dlq-name)."
    }

    eks_core_cluster_name = {
      name        = "/safespot/${var.environment}/api-service/eks-core/cluster-name"
      value       = data.terraform_remote_state.eks_core.outputs.cluster_name
      description = "EKS core cluster name."
    }

    eks_core_cluster_endpoint = {
      name        = "/safespot/${var.environment}/api-service/eks-core/cluster-endpoint"
      value       = data.terraform_remote_state.eks_core.outputs.cluster_endpoint
      description = "EKS core cluster endpoint."
    }

    eks_core_oidc_provider_arn = {
      name        = "/safespot/${var.environment}/api-service/eks-core/oidc-provider-arn"
      value       = data.terraform_remote_state.eks_core.outputs.oidc_provider_arn
      description = "EKS core OIDC provider ARN."
    }

    route53_zone_id = {
      name        = "/safespot/${var.environment}/front-edge/route53-zone-id"
      value       = data.terraform_remote_state.front_edge.outputs.route53_zone_id
      description = "Route53 hosted zone ID."
    }

    route53_zone_name = {
      name        = "/safespot/${var.environment}/front-edge/route53-zone-name"
      value       = data.terraform_remote_state.front_edge.outputs.route53_zone_name
      description = "Route53 hosted zone name."
    }

    certificate_arn = {
      name        = "/safespot/${var.environment}/front-edge/certificate-arn"
      value       = data.terraform_remote_state.front_edge.outputs.certificate_arn
      description = "Primary ACM certificate ARN."
    }

    alb_certificate_arn = {
      name        = "/safespot/${var.environment}/front-edge/alb-certificate-arn"
      value       = data.terraform_remote_state.front_edge.outputs.alb_certificate_arn
      description = "ALB ACM certificate ARN."
    }

    cloudfront_domain_name = {
      name        = "/safespot/${var.environment}/front-edge/cloudfront-domain-name"
      value       = data.terraform_remote_state.front_edge.outputs.cloudfront_domain_name
      description = "CloudFront distribution domain name."
    }

    api_origin_domain_name = {
      name        = "/safespot/${var.environment}/front-edge/api-origin-domain-name"
      value       = data.terraform_remote_state.front_edge.outputs.api_origin_domain_name
      description = "API origin domain name."
    }

    api_core_irsa_role_arn = {
      name        = "/safespot/${var.environment}/api-service/irsa/api-core-role-arn"
      value       = data.terraform_remote_state.api_service_eks_irsa.outputs.api_core_irsa_role_arn
      description = "IRSA role ARN for api-core ServiceAccount."
    }

    api_public_read_irsa_role_arn = {
      name        = "/safespot/${var.environment}/api-service/irsa/api-public-read-role-arn"
      value       = data.terraform_remote_state.api_service_eks_irsa.outputs.api_public_read_irsa_role_arn
      description = "IRSA role ARN for api-public-read ServiceAccount."
    }

    external_ingestion_irsa_role_arn = {
      name        = "/safespot/${var.environment}/api-service/irsa/external-ingestion-role-arn"
      value       = data.terraform_remote_state.api_service_eks_irsa.outputs.external_ingestion_irsa_role_arn
      description = "IRSA role ARN for external-ingestion ServiceAccount."
    }

    pre_scaling_controller_irsa_role_arn = {
      name        = "/safespot/${var.environment}/api-service/irsa/pre-scaling-controller-role-arn"
      value       = data.terraform_remote_state.api_service_eks_irsa.outputs.pre_scaling_controller_irsa_role_arn
      description = "IRSA role ARN for pre-scaling-controller ServiceAccount."
    }

    yace_irsa_role_arn = {
      name        = "/safespot/${var.environment}/observability/yace/irsa-role-arn"
      value       = data.terraform_remote_state.ops.outputs.yace_irsa_role_arn
      description = "YACE IRSA role ARN from ops remote state"
    }

    grafana_irsa_role_arn = {
      name        = "/safespot/${var.environment}/observability/grafana/irsa-role-arn"
      value       = data.terraform_remote_state.ops.outputs.grafana_irsa_role_arn
      description = "Grafana CloudWatch datasource IRSA role ARN from ops remote state"
    }

    aurora_cluster_identifier = {
      name        = "/safespot/${var.environment}/data/aurora-cluster-identifier"
      value       = data.terraform_remote_state.data.outputs.aurora_cluster_identifier
      description = "Aurora cluster identifier for CloudWatch dimension."
    }

    redis_replication_group_id = {
      name        = "/safespot/${var.environment}/data/redis-replication-group-id"
      value       = data.terraform_remote_state.data.outputs.redis_replication_group_id
      description = "Redis replication group ID for CloudWatch dimension."
    }

    lambda_function_name = {
      name        = "/safespot/${var.environment}/async-worker/lambda-function-name"
      value       = data.terraform_remote_state.async_worker.outputs.lambda_function_name
      description = "Async-worker Lambda function name for CloudWatch FunctionName dimension."
    }
  }

  # Optional parameters: only included when the variable is non-empty.
  # ALB and TargetGroup ARN suffixes are created by AWS Load Balancer Controller (K8s Ingress),
  # not by Terraform, so they must be supplied manually after the controller creates them.
  optional_string_parameters = merge(
    var.alb_arn_suffix != "" ? {
      alb_arn_suffix = {
        name        = "/safespot/${var.environment}/front-edge/alb-arn-suffix"
        value       = var.alb_arn_suffix
        description = "ALB ARN suffix for CloudWatch metrics."
      }
    } : {},
    var.api_target_group_arn_suffix != "" ? {
      api_target_group_arn_suffix = {
        name        = "/safespot/${var.environment}/front-edge/api-target-group-arn-suffix"
        value       = var.api_target_group_arn_suffix
        description = "API TargetGroup ARN suffix for CloudWatch metrics."
      }
    } : {},
  )

  secure_parameter_paths = {
    rds_username = {
      name        = "/safespot/${var.environment}/secret/rds/username"
      type        = "SecureString"
      owner       = "data"
      description = "Managed outside Terraform."
    }

    rds_password = {
      name        = "/safespot/${var.environment}/secret/rds/password"
      type        = "SecureString"
      owner       = "data"
      description = "Managed outside Terraform."
    }

    jwt_access_token_key = {
      name        = "/safespot/${var.environment}/secret/jwt/access-token-key"
      type        = "SecureString"
      owner       = "api-service"
      description = "Managed outside Terraform."
    }

    jwt_refresh_token_key = {
      name        = "/safespot/${var.environment}/secret/jwt/refresh-token-key"
      type        = "SecureString"
      owner       = "api-service"
      description = "Managed outside Terraform."
    }

    openapi_service_key = {
      name        = "/safespot/${var.environment}/secret/openapi/service-key"
      type        = "SecureString"
      owner       = "api-service"
      description = "Managed outside Terraform."
    }

    weather_api_key = {
      name        = "/safespot/${var.environment}/secret/weather/api-key"
      type        = "SecureString"
      owner       = "api-service"
      description = "Managed outside Terraform."
    }

    air_quality_api_key = {
      name        = "/safespot/${var.environment}/secret/air-quality/api-key"
      type        = "SecureString"
      owner       = "api-service"
      description = "Managed outside Terraform."
    }

    grafana_admin_password = {
      name        = "/safespot/${var.environment}/secret/grafana/admin-password"
      type        = "SecureString"
      owner       = "ops"
      description = "Managed outside Terraform."
    }

    slack_webhook_url = {
      name        = "/safespot/${var.environment}/secret/slack/webhook-url"
      type        = "SecureString"
      owner       = "ops"
      description = "Managed outside Terraform."
    }
  }

}
