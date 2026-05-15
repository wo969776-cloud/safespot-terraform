data "terraform_remote_state" "data" {
  backend = "s3"

  config = {
    bucket = var.terraform_state_bucket
    key    = "environments/dev/data/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "async_worker" {
  backend = "s3"

  config = {
    bucket = var.terraform_state_bucket
    key    = "environments/dev/async-worker/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "eks_core" {
  backend = "s3"

  config = {
    bucket = var.terraform_state_bucket
    key    = "environments/dev/api-service/eks-core/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "front_edge" {
  backend = "s3"

  config = {
    bucket = var.terraform_state_bucket
    key    = "environments/dev/edge/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "api_service_eks_irsa" {
  backend = "s3"

  config = {
    bucket = var.terraform_state_bucket
    key    = "environments/dev/api-service/eks-irsa/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "ops" {
  backend = "s3"

  config = {
    bucket = var.terraform_state_bucket
    key    = "environments/dev/ops/terraform.tfstate"
    region = var.aws_region
  }
}
