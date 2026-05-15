module "argocd_bootstrap" {
  source = "../../../../modules/api-service/argocd-bootstrap"

  argocd_namespace     = var.argocd_namespace
  argocd_chart_version = var.argocd_chart_version

  repo_url        = var.repo_url
  target_revision = var.target_revision
  addons_path     = var.addons_path

  argocd_node_selector = var.argocd_node_selector
  argocd_tolerations   = var.argocd_tolerations
}
