# Terraform Naming Convention Contract

## 1. 목적

본 문서는 Terraform 리소스 네이밍 규칙을 정의한다.

## 2. 리소스 네이밍 규칙

README 기준:

```text
{project}-{env}-{domain}-{resource_type}-{name}
```

## 3. 예시

```text
safespot-dev-network-vpc-main
safespot-dev-compute-eks-cluster
safespot-dev-data-rds-primary
```

## 4. 케이스 규칙

| 항목 | 규칙 |
|---|---|
| Terraform 변수 / locals | snake_case |
| AWS 리소스 이름 | kebab-case |
| 태그 키 | PascalCase |

## 5. 미정 / README에 없음

| 항목 | 상태 |
|---|---|
| resource_type 표준 목록 정의 | README에 없음 |
| name 필드 네이밍 규칙 상세 | README에 없음 |
| 도메인 값 표준 목록 | README에 없음 |
