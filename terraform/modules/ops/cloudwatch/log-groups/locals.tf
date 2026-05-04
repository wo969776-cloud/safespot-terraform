# modules/ops/log-groups/locals.tf

locals {
  name_prefix = "safespot-${var.env}"

  # KMS Key ARN이 지정된 경우에만 암호화 적용
  kms_key_arn = var.kms_key_arn != "" ? var.kms_key_arn : null

  # ── Log Group 이름 규칙 ────────────────────────────────────────────────────
  #
  # EKS control plane : /aws/eks/{cluster_name}/cluster  (AWS 고정 형식)
  # Lambda            : /aws/lambda/{function_name}      (AWS 고정 형식)
  # Application       : /safespot/{env}/{service}        (프로젝트 규칙)
  # ALB access log    : /safespot/{env}/alb/access-log   (선택)

  # Application Log Group 이름 map
  app_log_group_names = {
    for svc in var.services :
    svc => "/safespot/${var.env}/${svc}"
  }

  # EKS control plane Log Group 이름 (AWS 고정 형식)
  eks_control_plane_log_group_name = "/aws/eks/${var.eks_cluster_name}/cluster"

  # Lambda Log Group 이름 (AWS 고정 형식)
  lambda_log_group_name = "/aws/lambda/${var.lambda_function_name}"

  # ALB access log용 Log Group 이름 (enable_alb_log_group = true 시 생성)
  alb_log_group_name = "/safespot/${var.env}/alb/access-log"
}