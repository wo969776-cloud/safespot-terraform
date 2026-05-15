# SafeSpot dev Secret 주입 매뉴얼

이 문서는 `dev` 환경의 SSM `SecureString` Parameter 값을 Terraform 외부에서 주입하는 절차를 정의한다.

Terraform은 secret 값을 생성하거나 관리하지 않는다. Secret 값은 `.tf`, `.tfvars`, `locals`, `outputs`, Terraform state, Git commit에 남기지 않는다.

## 전제 조건

- AWS CLI 인증 프로파일: `safespot-dev`
- AWS Region: `ap-northeast-2`
- 대상 환경: `dev`
- SSM Parameter type: `SecureString`
- 값 등록 주체: AWS CLI, AWS Console, CI secret store 중 하나

필요 IAM 권한:

```text
ssm:PutParameter
ssm:GetParameter
ssm:DescribeParameters
```

고객 관리형 KMS key를 사용할 경우 다음 권한도 필요하다.

```text
kms:Encrypt
kms:Decrypt
kms:DescribeKey
```

## Secret 경로 계약

아래 경로는 Terraform이 리소스로 생성하지 않는다. 애플리케이션과 플랫폼이 참조할 경로 계약만 Terraform output으로 제공한다.

| Key | SSM Parameter name | Owner |
|---|---|---|
| `rds_username` | `/safespot/dev/secret/rds/username` | `data` |
| `rds_password` | `/safespot/dev/secret/rds/password` | `data` |
| `jwt_access_token_key` | `/safespot/dev/secret/jwt/access-token-key` | `api-service` |
| `jwt_refresh_token_key` | `/safespot/dev/secret/jwt/refresh-token-key` | `api-service` |
| `openapi_service_key` | `/safespot/dev/secret/openapi/service-key` | `api-service` |
| `weather_api_key` | `/safespot/dev/secret/weather/api-key` | `api-service` |
| `air_quality_api_key` | `/safespot/dev/secret/air-quality/api-key` | `api-service` |
| `grafana_admin_password` | `/safespot/dev/secret/grafana/admin-password` | `ops` |
| `slack_webhook_url` | `/safespot/dev/secret/slack/webhook-url` | `ops` |

## 등록 원칙

1. Secret 값을 명령어에 직접 쓰지 않는다.
2. Secret 값을 shell history, Terraform 파일, Git tracked 파일에 남기지 않는다.
3. `--overwrite`는 값 회전 또는 재등록이 필요한 경우에만 사용한다.
4. 등록 후 값 자체를 출력하지 않는다.
5. 검증은 기본적으로 `--with-decryption` 없이 metadata만 확인한다.

## 단건 등록

로컬 단건 등록 시 값은 표준 입력으로만 받는다.

```bash
export AWS_PROFILE="safespot-dev"
export AWS_REGION="ap-northeast-2"
export PARAMETER_NAME="/safespot/dev/secret/rds/password"

read -r -s SECRET_VALUE
printf '\n'

aws ssm put-parameter \
  --name "$PARAMETER_NAME" \
  --type "SecureString" \
  --value "$SECRET_VALUE" \
  --overwrite \
  --region "$AWS_REGION"

unset SECRET_VALUE
unset PARAMETER_NAME
```

주의: `--value "$SECRET_VALUE"`는 shell history에는 남지 않지만, 실행 순간 같은 호스트의 privileged user가 process argv를 볼 수 있다. 공유 서버에서는 AWS Console 또는 CI secret store를 사용한다.

## CI에서 등록

CI에서는 secret store에 저장된 값을 환경 변수로 주입한 뒤 AWS CLI를 실행한다. CI 로그에 값이 출력되지 않도록 echo, debug trace, `set -x`를 사용하지 않는다.

```bash
set +x

aws ssm put-parameter \
  --name "/safespot/dev/secret/jwt/access-token-key" \
  --type "SecureString" \
  --value "$JWT_ACCESS_TOKEN_KEY" \
  --overwrite \
  --profile "safespot-dev" \
  --region "ap-northeast-2"
```

## 일괄 등록용 로컬 스크립트

아래 스크립트는 각 경로별 값을 대화형으로 입력받아 등록한다. 값은 화면에 표시되지 않는다.

```bash
#!/usr/bin/env bash
set -euo pipefail

export AWS_PROFILE="safespot-dev"
export AWS_REGION="ap-northeast-2"

put_secret() {
  local name="$1"
  local value

  printf '%s: ' "$name" >&2
  read -r -s value
  printf '\n' >&2

  aws ssm put-parameter \
    --name "$name" \
    --type "SecureString" \
    --value "$value" \
    --overwrite \
    --region "$AWS_REGION" >/dev/null

  unset value
}

put_secret "/safespot/dev/secret/rds/username"
put_secret "/safespot/dev/secret/rds/password"
put_secret "/safespot/dev/secret/jwt/access-token-key"
put_secret "/safespot/dev/secret/jwt/refresh-token-key"
put_secret "/safespot/dev/secret/openapi/service-key"
put_secret "/safespot/dev/secret/weather/api-key"
put_secret "/safespot/dev/secret/air-quality/api-key"
put_secret "/safespot/dev/secret/grafana/admin-password"
put_secret "/safespot/dev/secret/slack/webhook-url"
```

이 스크립트를 저장해야 한다면 Git에 commit하지 않는 임시 위치에 둔다. 실행 후 파일이 불필요하면 삭제한다.

## 등록 확인

값을 복호화하지 않고 Parameter 존재 여부와 type만 확인한다.

```bash
aws ssm get-parameter \
  --name "/safespot/dev/secret/rds/password" \
  --profile "safespot-dev" \
  --region "ap-northeast-2" \
  --query "Parameter.{Name:Name,Type:Type,Version:Version,LastModifiedDate:LastModifiedDate}" \
  --output table
```

전체 경로를 확인한다.

```bash
aws ssm describe-parameters \
  --parameter-filters "Key=Name,Option=BeginsWith,Values=/safespot/dev/secret/" \
  --profile "safespot-dev" \
  --region "ap-northeast-2" \
  --query "Parameters[].{Name:Name,Type:Type,Version:Version,LastModifiedDate:LastModifiedDate}" \
  --output table
```

## 값 회전

Secret 회전은 동일 경로에 새 값을 `--overwrite`로 등록한다.

```bash
export AWS_PROFILE="safespot-dev"
export AWS_REGION="ap-northeast-2"
export PARAMETER_NAME="/safespot/dev/secret/slack/webhook-url"

read -r -s SECRET_VALUE
printf '\n'

aws ssm put-parameter \
  --name "$PARAMETER_NAME" \
  --type "SecureString" \
  --value "$SECRET_VALUE" \
  --overwrite \
  --region "$AWS_REGION"

unset SECRET_VALUE
unset PARAMETER_NAME
```

회전 후 애플리케이션이 SSM 값을 캐시한다면 재시작 또는 설정 reload 절차를 별도로 수행한다.

## 금지 사항

다음 방식은 사용하지 않는다.

```bash
terraform apply -var="rds_password=..."
```

```hcl
locals {
  rds_password = "..."
}
```

```hcl
resource "aws_ssm_parameter" "secret" {
  type  = "SecureString"
  value = "..."
}
```

금지 사유는 secret 값이 shell history, Git, Terraform state, plan output, CI 로그 중 하나에 남을 수 있기 때문이다.

## 장애 대응

`ParameterAlreadyExists`:

- 기존 값을 유지해야 하면 등록을 중단한다.
- 값 회전이 목적이면 `--overwrite`를 사용한다.

`AccessDeniedException`:

- `ssm:PutParameter` 권한을 확인한다.
- 고객 관리형 KMS key를 사용하는 경우 KMS key policy와 `kms:Encrypt` 권한을 확인한다.

애플리케이션에서 값을 읽지 못함:

- Parameter name 오타를 확인한다.
- 애플리케이션 IAM role에 `ssm:GetParameter`와 필요한 경우 `kms:Decrypt`가 있는지 확인한다.
- Region이 `ap-northeast-2`인지 확인한다.
