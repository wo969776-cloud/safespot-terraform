# terraform.tfvars
project     = "safespot"
environment = "dev"

github_org = "project-safespot"

github_repos = [
  "project-safespot/safespot-terraform",
  "project-safespot/safespot-application",
  "project-safespot/safespot-front",
  "project-safespot/safespot-ops",
  "project-safespot/safespot-application-k8s-manifest",
]

terraform_state_bucket = "safespot-terraform-state"