resource "aws_iam_policy" "alb_controller" {
  name        = local.alb_controller_policy_name
  description = "IAM policy for AWS Load Balancer Controller on ${local.cluster_name}."
  policy      = file("${path.module}/policies/aws-load-balancer-controller-policy.json")

  tags = merge(local.common_tags, {
    Name      = local.alb_controller_policy_name
    Workload  = "aws-load-balancer-controller"
    Namespace = var.alb_controller_namespace
  })
}

module "alb_controller_irsa" {
  source = "../../../../modules/api-service/eks-irsa"

  role_name            = local.alb_controller_role_name
  oidc_provider_arn    = local.oidc_provider_arn
  oidc_provider        = local.oidc_provider
  namespace            = var.alb_controller_namespace
  service_account_name = var.alb_controller_service_account_name

  managed_policy_arns = {
    alb_controller = aws_iam_policy.alb_controller.arn
  }

  tags = local.common_tags
}

# ── api-core ──────────────────────────────────────────────────────────────────

data "aws_iam_policy_document" "api_core_sqs" {
  statement {
    sid       = "AllowSendMessageToCoreEventQueue"
    effect    = "Allow"
    actions   = ["sqs:SendMessage"]
    resources = [local.api_core_event_queue_arn]
  }
}

resource "aws_iam_policy" "api_core_sqs" {
  name        = local.api_core_policy_name
  description = "IAM policy for api-core SQS access on ${local.cluster_name}."
  policy      = data.aws_iam_policy_document.api_core_sqs.json

  tags = merge(local.common_tags, {
    Name      = local.api_core_policy_name
    Workload  = "api-core"
    Namespace = var.app_namespace
  })
}

module "api_core_irsa" {
  source = "../../../../modules/api-service/eks-irsa"

  role_name            = local.api_core_role_name
  oidc_provider_arn    = local.oidc_provider_arn
  oidc_provider        = local.oidc_provider
  namespace            = var.app_namespace
  service_account_name = var.api_core_service_account_name

  managed_policy_arns = {
    sqs = aws_iam_policy.api_core_sqs.arn
  }

  tags = local.common_tags
}

# ── api-public-read ───────────────────────────────────────────────────────────

data "aws_iam_policy_document" "api_public_read_sqs" {
  statement {
    sid    = "AllowSendMessageToCacheQueues"
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueAttributes",
    ]
    resources = [
      local.api_public_read_cache_refresh_queue_arn,
      local.api_public_read_readmodel_refresh_queue_arn,
      local.api_public_read_environment_cache_refresh_queue_arn,
    ]
  }
}

resource "aws_iam_policy" "api_public_read_sqs" {
  name        = local.api_public_read_policy_name
  description = "IAM policy for api-public-read SQS access on ${local.cluster_name}."
  policy      = data.aws_iam_policy_document.api_public_read_sqs.json

  tags = merge(local.common_tags, {
    Name      = local.api_public_read_policy_name
    Workload  = "api-public-read"
    Namespace = var.app_namespace
  })
}

module "api_public_read_irsa" {
  source = "../../../../modules/api-service/eks-irsa"

  role_name            = local.api_public_read_role_name
  oidc_provider_arn    = local.oidc_provider_arn
  oidc_provider        = local.oidc_provider
  namespace            = var.app_namespace
  service_account_name = var.api_public_read_service_account_name

  managed_policy_arns = {
    sqs = aws_iam_policy.api_public_read_sqs.arn
  }

  tags = local.common_tags
}

# ── external-ingestion ────────────────────────────────────────────────────────

data "aws_iam_policy_document" "external_ingestion_sqs" {
  statement {
    sid    = "AllowSendMessageToCacheQueues"
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueAttributes",
    ]
    resources = [
      local.external_ingestion_cache_refresh_queue_arn,
      local.external_ingestion_readmodel_refresh_queue_arn,
      local.external_ingestion_environment_cache_refresh_queue_arn,
    ]
  }
}

resource "aws_iam_policy" "external_ingestion_sqs" {
  name        = local.external_ingestion_policy_name
  description = "IAM policy for external-ingestion SQS access on ${local.cluster_name}."
  policy      = data.aws_iam_policy_document.external_ingestion_sqs.json

  tags = merge(local.common_tags, {
    Name      = local.external_ingestion_policy_name
    Workload  = "external-ingestion"
    Namespace = var.app_namespace
  })
}

module "external_ingestion_irsa" {
  source = "../../../../modules/api-service/eks-irsa"

  role_name            = local.external_ingestion_role_name
  oidc_provider_arn    = local.oidc_provider_arn
  oidc_provider        = local.oidc_provider
  namespace            = var.app_namespace
  service_account_name = var.external_ingestion_service_account_name

  managed_policy_arns = {
    sqs = aws_iam_policy.external_ingestion_sqs.arn
  }

  tags = local.common_tags
}

# ── pre-scaling-controller ───────────────────────────────────────────────────
#
# The controller talks to the Kubernetes API through RBAC. A dedicated IRSA role
# keeps the ServiceAccount contract explicit and allows AWS permissions to be
# added later without reworking the manifest/SSM value path.
module "pre_scaling_controller_irsa" {
  source = "../../../../modules/api-service/eks-irsa"

  role_name            = local.pre_scaling_controller_role_name
  oidc_provider_arn    = local.oidc_provider_arn
  oidc_provider        = local.oidc_provider
  namespace            = var.app_namespace
  service_account_name = var.pre_scaling_controller_service_account_name

  managed_policy_arns = {}

  tags = local.common_tags
}
