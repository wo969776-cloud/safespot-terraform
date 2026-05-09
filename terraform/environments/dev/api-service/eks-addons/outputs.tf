output "ebs_csi_addon_arn" {
  description = "ARN of the AWS EBS CSI EKS addon"
  value       = aws_eks_addon.ebs_csi.arn
}

output "ebs_csi_addon_name" {
  description = "Name of the AWS EBS CSI EKS addon"
  value       = aws_eks_addon.ebs_csi.addon_name
}

output "gp3_storage_class_name" {
  description = "Name of the gp3 StorageClass"
  value       = kubernetes_storage_class_v1.gp3.metadata[0].name
}
