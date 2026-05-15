# ============================================================
# AWS EBS CSI Driver EKS Addon
# ============================================================
resource "aws_eks_addon" "ebs_csi" {
  cluster_name             = local.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = local.ebs_csi_irsa_role_arn

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = merge(local.common_tags, {
    Name      = "${var.project}-${var.environment}-aws-ebs-csi-driver"
    AddonName = "aws-ebs-csi-driver"
  })
}

# ============================================================
# gp3 StorageClass
# ============================================================
resource "kubernetes_storage_class_v1" "gp3" {
  metadata {
    name = "gp3"

    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "false"
    }
  }

  storage_provisioner = "ebs.csi.aws.com"

  parameters = {
    type   = "gp3"
    fsType = "ext4"
  }

  reclaim_policy         = "Delete"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true

  depends_on = [
    aws_eks_addon.ebs_csi
  ]
}
