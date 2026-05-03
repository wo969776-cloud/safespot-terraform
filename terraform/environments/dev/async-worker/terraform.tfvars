aws_region  = "ap-northeast-2"
project     = "safespot"
environment = "dev"
queue_name  = "event"

# visibility_timeout은 consumer 처리 시간보다 커야 한다
# 실제 Lambda timeout 기준으로 조정 필요
visibility_timeout_seconds = 180

# consumer 장애 시 이벤트 유실 방지를 위해 retention 확장
message_retention_seconds     = 345600
dlq_message_retention_seconds = 1209600
max_receive_count             = 5
