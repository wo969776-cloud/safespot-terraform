# Terraform Module Ownership Contract

## 1. 목적

본 문서는 SafeSpot Terraform 레포지토리에서 도메인별 소유권과 변경 책임을 정의한다.

## 2. Repository 구조 기준

README 기준 Terraform 구조는 다음과 같다.

```text
environments/dev/{domain} : 실행 단위 (terraform init/plan/apply 위치)
modules/{domain}/{resource} : 재사용 가능한 모듈
```

## 3. Apply 순서

도메인 간 의존성이 있으므로 README에 명시된 아래 순서를 따른다.

```text
network → data → compute → edge → messaging → application → cicd → observability
```

## 4. 도메인 담당자

| 도메인 | 정 | 부 | 비고 |
|---|---|---|---|
| network | jaeyoung | sohyun | README 기준 |
| data | danu | minjung | README 기준 |
| api+service | minjung | seohyun | README 기준 |
| cache | danu | minjung | README 기준 |
| async+worker | seohyun | minjung | README 기준 |
| front+edge | jaeyoung | seohyun | README 기준 |
| ops | sohyun | seohyun, danu, jaeyoung | README 기준 |

## 5. 변경 규칙

- 담당 도메인 외 변경 시 CODEOWNERS 리뷰가 필요하다.
- main 브랜치 직접 push는 금지한다.
- 모든 변경은 PR로 반영한다.

## 6. 미정 / README에 없음

아래 항목은 README에 명시되어 있지 않아 본 문서에서 임의로 확정하지 않는다.

| 항목 | 상태 |
|---|---|
| 각 도메인별 정확한 AWS 리소스 소유 범위 | README에 없음 |
| `infra/*` 브랜치와 도메인 매핑 | README에 없음 |
| CODEOWNERS 실제 매핑 규칙 | README에 없음 |
| 공통 파일(`provider.tf`, `backend.tf`, `versions.tf`) 수정 권한 | README에 없음 |
| 도메인 간 output/input 계약 형식 | README에 없음 |
