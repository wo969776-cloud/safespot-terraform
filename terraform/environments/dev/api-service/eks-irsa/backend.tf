terraform {
  backend "s3" {
    bucket = "safespot-terraform-state"
    key    = "environments/dev/api-service/eks-irsa/terraform.tfstate"
    region = "ap-northeast-2"
  }
}
