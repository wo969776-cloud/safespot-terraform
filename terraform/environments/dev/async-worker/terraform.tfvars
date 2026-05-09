aws_region  = "ap-northeast-2"
project     = "safespot"
environment = "dev"

# visibility_timeout은 lambda_timeout(120s)보다 커야 한다
visibility_timeout_seconds = 180

# consumer 장애 시 이벤트 유실 방지를 위해 retention 확장
message_retention_seconds     = 345600
dlq_message_retention_seconds = 1209600
max_receive_count             = 5

# lambda_filename은 CI/CD 파이프라인에서 -var="lambda_filename=<path>" 으로 주입
# 예: terraform apply -var="lambda_filename=./build/async-worker-lambda-0.0.1-SNAPSHOT.zip"
lambda_handler    = "com.safespot.asyncworker.AsyncWorkerHandler::handleRequest"
metrics_namespace = "SafeSpot/AsyncWorker"
