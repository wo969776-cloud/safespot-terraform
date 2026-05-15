env     = "dev"
project = "safespot"

remote_state_bucket    = "safespot-terraform-state"
eks_core_state_key     = "environments/dev/api-service/eks-core/terraform.tfstate"
async_worker_state_key = "environments/dev/async-worker/terraform.tfstate"

alb_controller_namespace            = "kube-system"
alb_controller_service_account_name = "aws-load-balancer-controller"

app_namespace                           = "application"
api_core_service_account_name           = "api-core"
api_public_read_service_account_name    = "api-public-read"
external_ingestion_service_account_name = "external-ingestion"

