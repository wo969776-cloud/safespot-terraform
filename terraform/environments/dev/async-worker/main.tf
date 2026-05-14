data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "safespot-terraform-state"
    key    = "environments/dev/network/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

data "terraform_remote_state" "data" {
  backend = "s3"
  config = {
    bucket = "safespot-terraform-state"
    key    = "environments/dev/data/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

data "aws_ssm_parameter" "db_username" {
  name            = "/safespot/dev/secret/rds/username"
  with_decryption = true
}

data "aws_ssm_parameter" "db_password" {
  name            = "/safespot/dev/secret/rds/password"
  with_decryption = true
}

module "sqs" {
  source = "../../../modules/async-worker/sqs"

  project     = var.project
  environment = var.environment

  visibility_timeout_seconds    = var.visibility_timeout_seconds
  message_retention_seconds     = var.message_retention_seconds
  dlq_message_retention_seconds = var.dlq_message_retention_seconds
  max_receive_count             = var.max_receive_count

  common_tags = local.common_tags
}

module "lambda" {
  source = "../../../modules/async-worker/lambda"

  project     = var.project
  environment = var.environment

  # path.root = terraform/environments/dev/async-worker 기준 절대경로로 변환
  lambda_filename = var.lambda_filename
  lambda_handler  = var.lambda_handler

  # readmodel-worker: @Profile("readmodel-worker") 조건 핸들러 활성화
  spring_profiles_active = "${var.environment},readmodel-worker"

  cache_refresh_queue_arn             = module.sqs.cache_refresh_queue_arn
  readmodel_refresh_queue_arn         = module.sqs.readmodel_refresh_queue_arn
  environment_cache_refresh_queue_arn = module.sqs.environment_cache_refresh_queue_arn

  private_subnet_ids = data.terraform_remote_state.network.outputs.private_app_subnet_ids
  lambda_sg_id       = data.terraform_remote_state.network.outputs.lambda_sg_id

  db_host           = data.terraform_remote_state.data.outputs.aurora_cluster_endpoint
  db_port           = data.terraform_remote_state.data.outputs.aurora_port
  db_name           = data.terraform_remote_state.data.outputs.aurora_db_name
  db_user           = data.aws_ssm_parameter.db_username.value
  db_password       = data.aws_ssm_parameter.db_password.value
  redis_host        = data.terraform_remote_state.data.outputs.redis_primary_endpoint
  metrics_namespace = var.metrics_namespace

  common_tags = local.common_tags
}
