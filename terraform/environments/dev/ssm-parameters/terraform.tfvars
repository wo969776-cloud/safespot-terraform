aws_region = "ap-northeast-2"
project    = "safespot"
env        = "dev"

ssm_parameters = {
  "common/aws-region" = {
    value       = "ap-northeast-2"
    type        = "String"
    description = "AWS region"
  }

  "common/spring-profile" = {
    value       = "dev"
    type        = "String"
    description = "Spring profile"
  }

  "common/redis-port" = {
    value       = "6379"
    type        = "String"
    description = "Redis port"
  }

  "api-core/db-password" = {
    value       = "CHANGE_ME"
    type        = "SecureString"
    description = "api-core database password"
  }

  "api-core/jwt-secret" = {
    value       = "CHANGE_ME"
    type        = "SecureString"
    description = "api-core JWT secret"
  }
}
