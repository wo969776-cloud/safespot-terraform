# eks-irsa

SafeSpot EKS 환경에서 Kubernetes ServiceAccount와 AWS IAM Role을 연결하기 위한 Terraform child module입니다.

이 모듈은 IRSA 방식으로 특정 Kubernetes ServiceAccount가 특정 IAM Role을 assume할 수 있도록 trust policy를 구성합니다.

---

## Responsibility

### Included

- IAM Role
- IRSA trust policy
- Managed IAM policy attachment
- Optional inline IAM policy
- Role ARN output

### Excluded

- Kubernetes ServiceAccount creation
- Helm release installation
- Kubernetes workload deployment
- AWS Load Balancer Controller installation
- Karpenter installation

---

## IRSA Subject Format

```text
system:serviceaccount:<namespace>:<service-account-name>
```

Example:

```text
system:serviceaccount:kube-system:aws-load-balancer-controller
```

---

## Usage

```hcl
module "alb_controller_irsa" {
  source = "../../../../modules/api-service/eks-irsa"

  role_name            = "safespot-dev-aws-load-balancer-controller-irsa"
  oidc_provider_arn    = var.oidc_provider_arn
  oidc_provider        = var.oidc_provider
  namespace            = "kube-system"
  service_account_name = "aws-load-balancer-controller"

  managed_policy_arns = [
    aws_iam_policy.alb_controller.arn
  ]

  tags = local.common_tags
}
```

---

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.34, < 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_inline_policy_json"></a> [inline\_policy\_json](#input\_inline\_policy\_json) | Optional inline IAM policy JSON for the IRSA role. | `string` | `null` | no |
| <a name="input_managed_policy_arns"></a> [managed\_policy\_arns](#input\_managed\_policy\_arns) | Managed IAM policy ARNs to attach to the IRSA role. | `list(string)` | `[]` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace of the service account. | `string` | n/a | yes |
| <a name="input_oidc_provider"></a> [oidc\_provider](#input\_oidc\_provider) | EKS OIDC provider URL without https:// prefix. | `string` | n/a | yes |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | EKS OIDC provider ARN. | `string` | n/a | yes |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | IAM role name for the Kubernetes service account. | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Kubernetes service account name. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags for resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Kubernetes namespace. |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | IAM role ARN. |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | IAM role name. |
| <a name="output_service_account_name"></a> [service\_account\_name](#output\_service\_account\_name) | Kubernetes service account name. |
| <a name="output_service_account_subject"></a> [service\_account\_subject](#output\_service\_account\_subject) | Kubernetes service account subject used in IRSA trust policy. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

````

---

# 8. 검증

```bash
terraform fmt -recursive terraform/modules/api-service/eks-irsa
````

모듈 단독 validate는 provider/backend context가 없어서 root module에서 하는 게 더 정확합니다. 그래도 문법 수준 확인은 가능합니다.

```bash
cd terraform/modules/api-service/eks-irsa
terraform init -backend=false
terraform validate
```

---
