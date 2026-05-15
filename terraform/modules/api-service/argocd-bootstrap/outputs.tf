output "argocd_namespace" {
  description = "ArgoCD Kubernetes namespace."
  value       = kubernetes_namespace_v1.argocd.metadata[0].name
}

output "argocd_chart_version" {
  description = "Installed ArgoCD Helm chart version."
  value       = helm_release.argocd.version
}

output "root_application_name" {
  description = "Name of the ArgoCD root Application."
  value       = kubernetes_manifest.root_app.manifest.metadata.name
}
