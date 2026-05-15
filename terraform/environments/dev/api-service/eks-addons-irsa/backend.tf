terraform {
  backend "s3" {
    bucket  = "safespot-terraform-state"
    key     = "environments/dev/api-service/eks-addons-irsa/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}
