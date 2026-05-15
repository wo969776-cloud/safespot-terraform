output "argocd_namespace" {
  description = "ArgoCD Kubernetes namespace."
  value       = module.argocd_bootstrap.argocd_namespace
}

output "argocd_chart_version" {
  description = "Installed ArgoCD Helm chart version."
  value       = module.argocd_bootstrap.argocd_chart_version
}

output "root_application_name" {
  description = "Name of the ArgoCD root Application."
  value       = module.argocd_bootstrap.root_application_name
}
