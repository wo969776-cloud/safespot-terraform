# SafeSpot dev ssm-parameters

`ssm-parameters`는 초기 bootstrap 모듈이 아니라 모든 인프라 apply 이후 실행하는 runtime configuration aggregation layer다.

## 역할

1. `ssm-parameters`는 마지막 apply 대상이다.
2. Terraform은 비민감 `String` Parameter만 생성한다.
3. `SecureString` value는 Terraform으로 생성하거나 관리하지 않는다.
4. Secret은 AWS CLI, AWS Console, CI 등 Terraform 외부 경로로 등록한다.

## Apply 순서

```text
network
-> data
-> async-worker
-> api-service/*
-> front-edge
-> ssm-parameters
```

`ssm-parameters`는 다음 Terraform remote state output을 읽어 런타임 설정용 SSM Parameter를 생성한다.

- `data`
- `async-worker`
- `api-service/eks-core`
- `front-edge`

## Terraform 관리 대상

Terraform은 `/safespot/dev/app`, `/safespot/dev/api`, `/safespot/dev/data`, `/safespot/dev/async-worker`, `/safespot/dev/api-service/eks-core`, `/safespot/dev/front-edge` 하위의 비민감 `String` Parameter만 관리한다.

VPC/Subnet ID, Security Group ID, DLQ, Queue ARN, Cluster ARN, WAF, CloudFront distribution ID, 대량 JSON 목록, secret value는 SSM 관리 대상에서 제외한다.

## SecureString 등록 예시

Secret 값은 Terraform 파일, tfvars, locals, output, state에 저장하지 않는다. 로컬 셸이나 CI secret store에서 값을 주입해 등록한다.

```bash
read -r -s RDS_PASSWORD

aws ssm put-parameter \
  --name "/safespot/dev/secret/rds/password" \
  --type "SecureString" \
  --value "$RDS_PASSWORD" \
  --overwrite \
  --profile safespot-dev \
  --region ap-northeast-2
```

다른 SecureString도 동일한 방식으로 `outputs.secure_parameter_paths`에 정의된 경로에 등록한다.

## 실행

```bash
terraform init
terraform validate
terraform plan
```
