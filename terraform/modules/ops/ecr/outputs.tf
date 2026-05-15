output "repository_urls" {
  description = "서비스별 ECR Repository URL map"

  value = {
    for k, v in aws_ecr_repository.services :
    k => v.repository_url
  }
}

output "repository_arns" {
  description = "서비스별 ECR Repository ARN map"

  value = {
    for k, v in aws_ecr_repository.services :
    k => v.arn
  }
}

output "repository_names" {
  description = "서비스별 ECR Repository 이름 map"

  value = {
    for k, v in aws_ecr_repository.services :
    k => v.name
  }
}

output "registry_id" {
  description = "ECR Registry ID. services가 비어있으면 null 반환"

  value = (
    length(aws_ecr_repository.services) > 0
    ? values(aws_ecr_repository.services)[0].registry_id
    : null
  )
}