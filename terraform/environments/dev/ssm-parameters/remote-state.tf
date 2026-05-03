data "terraform_remote_state" "data" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = var.data_state_key
    region = var.aws_region
  }
}
