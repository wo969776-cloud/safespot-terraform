terraform {
  backend "s3" {
<<<<<<< HEAD
    bucket  = "safespot-terraform-state"
    key     = "environments/dev/edge/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
=======
    bucket         = "safespot-terraform-state"
    key            = "environments/dev/edge/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
>>>>>>> origin/infra/network
  }
}