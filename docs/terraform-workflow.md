# Terraform 실행 워크플로우

## 다른 환경에서 세팅

```bash
cat .vscode/extensions.txt | xargs -L 1 code --install-extension
```

## 실행 위치 규칙

* modules/ ❌ 실행 금지
* environments/* ✅ 여기서만 실행

---

## 기본 실행 절차

```bash
cd terraform/environments/dev/api-service

terraform init
terraform plan -out=tfplan

infracost breakdown --path=tfplan
```

---

## 이유

* modules = 재사용 코드 (단독 실행 불가)
* environments = 실제 인프라 구성 + 변수 주입

---

## 실수 방지 체크리스트

* 현재 위치에 .tf 파일 있는지 확인
* terraform init 실행 여부
* tfplan 파일 생성 확인

```
```
