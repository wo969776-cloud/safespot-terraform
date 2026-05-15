terraform {
  backend "s3" {
    bucket  = "safespot-terraform-state"
    key     = "environments/dev/api-service/eks-karpenter/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}
