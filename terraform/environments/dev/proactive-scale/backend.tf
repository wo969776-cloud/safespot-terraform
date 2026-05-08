terraform {
  backend "s3" {
    bucket  = "safespot-terraform-state"
    key     = "environments/dev/proactive-scale/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}
