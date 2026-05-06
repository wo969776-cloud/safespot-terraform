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
  }

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
