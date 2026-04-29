# Terraform Contracts

SafeSpot Terraform 작업에서 영역 간 충돌을 줄이기 위한 계약 문서 모음이다.

## 문서 목록

| 문서 | 목적 |
|---|---|
| `terraform-module-interface-contract.md` | 영역별 Terraform module input/output/resource/port 통합 계약 |
| `terraform-interface-open-issues.md` | 문서 간 불일치, 양측 확인 필요 사항, 확정 대기 이슈 목록 |
| `terraform-branch-strategy.md` | infra/docs 브랜치 전략, PR 흐름, merge 기준 |
| `terraform-apply-order.md` | environment별 apply 순서와 선행 조건 |
| `terraform-naming-convention.md` | branch, module, variable, AWS resource naming 규칙 |

## 운영 원칙

1. `docs/contracts` 브랜치는 Terraform 코드 구현 전에 계약을 정리하는 브랜치다.
2. `infra/*` 브랜치는 실제 Terraform 코드 구현 브랜치다.
3. 계약 변경은 먼저 `docs/contracts`에 반영하고, 이후 각 `infra/*` 브랜치에서 구현한다.
4. 확정되지 않은 항목은 구현하지 않고 `terraform-interface-open-issues.md`에 남긴다.
5. main 병합 전에는 open issue 중 해당 PR 영향 범위 항목을 반드시 확인한다.

## 현재 기준

- 기준 날짜: 2026-04-29
- 기준 문서: Notion 영역별 모듈 인터페이스 정의서
- 대상 환경: `dev`
