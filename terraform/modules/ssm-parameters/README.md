# modules/ssm-parameters

비민감 SSM `String` Parameter만 생성하는 재사용 Terraform 모듈이다.

이 모듈은 `SecureString`, KMS key, secret value를 생성하거나 관리하지 않는다. Parameter name은 호출자가 완성된 경로로 전달한다.

```hcl
module "ssm_parameters" {
  source = "../../../modules/ssm-parameters"

  parameters = {
    app_profile = {
      name        = "/safespot/dev/app/profile"
      value       = "dev"
      description = "SafeSpot runtime profile."
    }
  }
}
```
