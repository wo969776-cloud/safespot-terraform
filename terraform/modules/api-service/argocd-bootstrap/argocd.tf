locals {
  # Scheduling block shared across all ArgoCD components.
  # Ensures every Deployment/StatefulSet lands on system nodes only.
  # DaemonSet components do not exist in the standard argo-cd chart (v7.x).
  _scheduling = {
    nodeSelector = var.argocd_node_selector
    tolerations  = var.argocd_tolerations
  }

  argocd_scheduling_values = {
    global         = local._scheduling
    controller     = local._scheduling
    server         = local._scheduling
    repoServer     = local._scheduling
    applicationSet = local._scheduling
    notifications  = local._scheduling
    dex            = local._scheduling
    redis          = local._scheduling
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_chart_version
  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name

  # Scheduling values come first; argocd_values can override if needed.
  values = concat(
    [yamlencode(local.argocd_scheduling_values)],
    var.argocd_values != "" ? [var.argocd_values] : []
  )

  wait    = true
  timeout = 600
}
