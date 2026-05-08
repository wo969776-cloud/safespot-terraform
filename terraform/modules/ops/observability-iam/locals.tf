locals {
  name_prefix = "${var.project}-${var.environment}"

  fluentbit_log_group_arns = length(var.log_group_arns) > 0 ? var.log_group_arns : ["*"]

  yace_irsa_subject = "system:serviceaccount:${var.yace_namespace}:${var.yace_service_account_name}"
}
