locals {
  name_prefix = "${var.project}-${var.environment}"

  kms_key_arn = var.kms_key_arn != "" ? var.kms_key_arn : null

  app_log_group_names = {
    for svc in var.services :
    svc => "/${var.project}/${var.environment}/${svc}"
  }

  eks_control_plane_log_group_name = "/aws/eks/${var.eks_cluster_name}/cluster"

  lambda_log_group_name = "/aws/lambda/${var.lambda_function_name}"

  # [삭제] alb_log_bucket_name 참조 제거
  alb_log_group_name = "/${var.project}/${var.environment}/alb/access-log"
}
