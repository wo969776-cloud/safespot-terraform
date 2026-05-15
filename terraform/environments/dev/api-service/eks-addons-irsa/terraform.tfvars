aws_region = "ap-northeast-2"
project    = "safespot"
env        = "dev"

remote_state_bucket = "safespot-terraform-state"
eks_core_state_key  = "environments/dev/api-service/eks-core/terraform.tfstate"

external_dns_namespace            = "external-dns"
external_dns_service_account_name = "external-dns"

external_secrets_namespace            = "external-secrets"
external_secrets_service_account_name = "external-secrets"
