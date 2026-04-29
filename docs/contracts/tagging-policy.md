# Terraform Tagging Policy

## 1. 목적

모든 AWS 리소스에 공통 태그를 적용하여 비용 추적 및 관리 일관성을 유지한다.

## 2. 필수 태그

README 기준:

| 태그 키 | 값 예시 | 설명 |
|---|---|---|
| Project | safespot | 프로젝트명 |
| Environment | dev | 환경 |
| Domain | network | 담당 도메인 |
| ManagedBy | terraform | 관리 주체 |
| Service | safespot | 서비스명 |
| CostCenter | safespot-dev | 비용 추적 |

## 3. 적용 원칙

- 모든 리소스에 필수 태그 적용

## 4. 미정 / README에 없음

| 항목 | 상태 |
|---|---|
| 선택 태그 정의 | README에 없음 |
| 태그 자동화 방식 (locals, module 공통화) | README에 없음 |
| Environment 값 확장 (dev/stg/prod) | README에 없음 |
