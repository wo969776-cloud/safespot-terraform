data "terraform_remote_state" "eks_core" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = var.eks_core_state_key
    region = var.aws_region
  }
}

data "terraform_remote_state" "async_worker" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = var.async_worker_state_key
    region = var.aws_region
  }
}
