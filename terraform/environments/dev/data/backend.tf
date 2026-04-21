terraform {
  backend "s3" {
    bucket  = "safespot-terraform-state"
    key     = "environments/dev/data/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}
