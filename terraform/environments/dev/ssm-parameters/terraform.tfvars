aws_region             = "ap-northeast-2"
project                = "safespot"
environment            = "dev"
terraform_state_bucket = "safespot-terraform-state"

common_tags = {
  Project     = "SafeSpot"
  Environment = "dev"
  ManagedBy   = "Terraform"
  Area        = "ssm-parameters"
}

# Set after AWS Load Balancer Controller creates the ALB/TargetGroup via K8s Ingress.
# Leave empty to skip SSM parameter creation.
#
# ALB ARN suffix 조회:
#   aws elbv2 describe-load-balancers --names safespot-dev-alb \
#     --query 'LoadBalancers[0].LoadBalancerArn' --output text | sed 's|.*:loadbalancer/||'
# 예시: "app/safespot-dev-alb/1a2b3c4d5e6f7g8h"
alb_arn_suffix = ""

# TargetGroup ARN suffix 조회:
#   aws elbv2 describe-target-groups \
#     --query 'TargetGroups[?LoadBalancerArns!=`[]`].TargetGroupArn' --output json | \
#     jq -r '.[] | split(":targetgroup/")[1] | "targetgroup/" + .'
# 예시: "targetgroup/k8s-default-safespot-xxxxxxxx/1a2b3c4d5e6f7g8h"
api_target_group_arn_suffix = ""
