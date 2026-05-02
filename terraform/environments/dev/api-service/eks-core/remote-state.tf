data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = var.network_state_key
    region = var.aws_region
  }
}
