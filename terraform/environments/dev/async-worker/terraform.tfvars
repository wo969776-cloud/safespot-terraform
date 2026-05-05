aws_region  = "ap-northeast-2"
project     = "safespot"
environment = "dev"

# visibility_timeout은 lambda_timeout(120s)보다 커야 한다
visibility_timeout_seconds = 180

# consumer 장애 시 이벤트 유실 방지를 위해 retention 확장
message_retention_seconds     = 345600
dlq_message_retention_seconds = 1209600
max_receive_count             = 5

# Lambda 배포 패키지 (Terraform 실행 위치 기준 상대경로)
lambda_filename = "../../../../services/async-worker/build/distributions/async-worker-lambda-0.0.1-SNAPSHOT.zip"
lambda_handler  = "com.safespot.asyncworker.handler.AsyncWorkerHandler::handleRequest"
