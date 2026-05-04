output "app_log_group_names" {
  description = "서비스별 Application Log Group 이름 map"

  value = {
    for k, v in aws_cloudwatch_log_group.application :
    k => v.name
  }
}

output "app_log_group_arns" {
  description = "서비스별 Application Log Group ARN map"

  value = {
    for k, v in aws_cloudwatch_log_group.application :
    k => v.arn
  }
}

output "eks_control_plane_log_group_name" {
  description = "EKS control plane Log Group 이름"
  value       = aws_cloudwatch_log_group.eks_control_plane.name
}

output "eks_control_plane_log_group_arn" {
  description = "EKS control plane Log Group ARN"
  value       = aws_cloudwatch_log_group.eks_control_plane.arn
}

output "lambda_log_group_name" {
  description = "Lambda Log Group 이름. lambda_function_name이 비어있으면 null 반환"

  value = (
    var.lambda_function_name != null && trimspace(var.lambda_function_name) != ""
    ? aws_cloudwatch_log_group.lambda[0].name
    : null
  )
}

output "lambda_log_group_arn" {
  description = "Lambda Log Group ARN. lambda_function_name이 비어있으면 null 반환"

  value = (
    var.lambda_function_name != null && trimspace(var.lambda_function_name) != ""
    ? aws_cloudwatch_log_group.lambda[0].arn
    : null
  )
}

output "alb_log_group_name" {
  description = "ALB access log CloudWatch Log Group 이름. enable_alb_log_group = false 이면 null 반환"

  value = (
    var.enable_alb_log_group
    ? aws_cloudwatch_log_group.alb_access_log[0].name
    : null
  )
}

output "alb_log_group_arn" {
  description = "ALB access log CloudWatch Log Group ARN. enable_alb_log_group = false 이면 null 반환"

  value = (
    var.enable_alb_log_group
    ? aws_cloudwatch_log_group.alb_access_log[0].arn
    : null
  )
}

output "all_log_group_arns" {
  description = "생성된 전체 Log Group ARN 목록"

  value = concat(
    values({
      for k, v in aws_cloudwatch_log_group.application :
      k => v.arn
    }),
    [aws_cloudwatch_log_group.eks_control_plane.arn],
    var.lambda_function_name != null && trimspace(var.lambda_function_name) != ""
      ? [aws_cloudwatch_log_group.lambda[0].arn]
      : [],
    var.enable_alb_log_group
      ? [aws_cloudwatch_log_group.alb_access_log[0].arn]
      : []
  )
}