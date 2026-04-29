# Terraform Interface Open Issues

이 문서는 Terraform 모듈 인터페이스 간 불일치, 확정 필요 사항을 정리한다.

---

## 1. 변수명 불일치

### 1.1 RDS SG
- data: `db_security_group_id`
- network: `rds_sg_id`
- compute: `rds_security_group_id`

→ **결정 필요: `rds_sg_id`로 통일 권장**

---

### 1.2 Redis SG
- data: `redis_security_group_id`
- network: `redis_sg_id`

→ **결정 필요: `redis_sg_id`로 통일 권장**

---

### 1.3 EKS SG
- network: `eks_node_sg_id`
- compute: `eks_node_security_group_id`

→ **결정 필요: `eks_node_sg_id`로 통일 권장**

---

## 2. Redis endpoint 구조

- data:
  - `redis_primary_endpoint`
  - `redis_reader_endpoint`
- compute:
  - `redis_endpoint`

→ 선택 필요:
1) read/write 분리 유지
2) 단일 endpoint로 단순화

---

## 3. data output 누락 가능성

현재 없음:
- `rds_port`
- `redis_port`
- `db_secret_arn`

async/compute에서 필요

→ **output 추가 여부 결정 필요**

---

## 4. apply 순서 불일치

README 기준:
network → data → compute → edge → messaging → application → cicd → observability

Notion 기준:
network → data → cache → async → compute → front-edge → ops

→ **단일 기준 필요**

---

## 5. Lambda SG 소유권

- async는 `lambda_sg_id` 요구
- network에는 정의 없음

→ 선택:
- network에서 생성
- async에서 생성

---

## 6. ALB 소유권

- compute: ALB 생성
- front-edge: ALB 의존 (WAF, Route53)

→ 소유권 명확화 필요

---

## 7. KMS 생성 시점

- ops에서 생성
- data에서 사용

→ 순서 문제 존재

---

## 8. NAT Gateway 활성화 시점

- network: 코드 존재, 주석 상태
- compute: 외부 API 호출 필요

→ 활성화 시점 확정 필요

---

## 9. DB 엔진 확정

- data: Aurora PostgreSQL
- 일부 문서: PostgreSQL

→ Aurora로 확정 필요

---

## 10. Redis replica 수

- data: replica 3
- 다른 문서: 미정

→ 확정 필요

---

## 운영 규칙

- 이 파일의 항목은 해결 전까지 코드 구현 금지
- 해결 시 반드시 해당 항목 삭제 또는 상태 변경
