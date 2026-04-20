# safespot-terraform

SafeSpot 팀 프로젝트 Terraform 레포지토리입니다.

## 구조
- `environments/dev/{domain}` : 실행 단위 (terraform init/plan/apply 위치)
- `modules/{domain}/{resource}` : 재사용 가능한 모듈

## Apply 순서
도메인 간 의존성이 있으므로 반드시 아래 순서를 지켜야 합니다.

network → data → compute → edge → messaging → application → cicd → observability

## 규칙
- 변수명은 snake_case 사용
- main 브랜치 직접 push 금지, PR로만 반영
- PR 승인 1명 이상 필요
- 담당 도메인 외 변경 시 CODEOWNERS 리뷰 필요

## 담당자
| 도메인 | 정 | 부 | 비고 |
|---|---|---|---|
| network | jaeyoung | sohyun | |
| data | danu | minjung | |
| api+service | minjung | seohyun | |
| cache | danu | minjung | |
| async+worker | seohyun | minjung | |
| front+edge | jaeyoung | seohyun | |
| ops | sohyun | seohyun, danu, jaeyoung | |

-------
## 네이밍 규칙
`{project}-{env}-{domain}-{resource_type}-{name}`

예시:
- safespot-dev-network-vpc-main
- safespot-dev-compute-eks-cluster
- safespot-dev-data-rds-primary

## 케이스 규칙
- Terraform 변수/locals: snake_case
- AWS 리소스 이름: kebab-case
- 태그 키: PascalCase

## 태그 규칙
모든 리소스에 아래 태그 필수 적용
| 태그 키 | 값 예시 | 설명 |
|---|---|---|
| Project | safespot | 프로젝트명 |
| Environment | dev | 환경 |
| Domain | network | 담당 도메인 |
| ManagedBy | terraform | 관리 주체 |
| Service | safespot | 서비스명 |
| CostCenter | safespot-dev | 비용 추적 |
