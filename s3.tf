#테라폼으로 이메일 주소를 자동으로 확인하는 것은 지원되지 않습니다 C:\Users\User\Desktop\trrr
#terraform init
#terraform plan -out=ttplan
#terraform apply "ttplan"
#terraform show
#terraform destroy

provider "aws" {
  region = "ap-northeast-2" # 사용할 AWS 리전을 선택합니다.
}


# S3 버킷 생성 및 ACL 설정
resource "aws_s3_bucket" "my_bucket" {
  bucket = "zootopic-s3-local-1q2w3e4r"
  acl    = "private"  # 퍼블릭 읽기 권한을 가진 ACL 설정
}

# S3 버킷의 public access block 설정
resource "aws_s3_bucket_public_access_block" "public-access" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# HTML 파일 업로드
resource "aws_s3_bucket_object" "html_file" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "home.html"  # 업로드할 HTML 파일의 이름
  source = "./web/home.html"  # 로컬 파일의 경로
  content_type = "text/html"
}

# CSS 파일 업로드
resource "aws_s3_bucket_object" "css_file" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "home.css"  # 업로드할 CSS 파일의 이름
  source = "./web/home.css"  # 로컬 파일의 경로
  content_type = "text/html"
}




#cloudfront

resource "aws_cloudfront_distribution" "my_distribution" {
  origin {
    domain_name = "zootopic-s3-local-1q2w3e4r.s3-website.ap-northeast-2.amazonaws.com"  # S3 버킷의 도메인 이름
    origin_id   = "S3Origin"
  }

  enabled             = true
  default_root_object = "home.html"  # 웹사이트의 기본 루트 객체

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}





#cognito

# Cognito 사용자 풀 생성
resource "aws_cognito_user_pool" "my_user_pool" {
  name = "my-user-pool"  # 사용자 풀의 이름을 지정합니다.

  # 이메일 속성을 사용하여 사용자 풀의 스키마를 정의합니다.
  schema {
    name              = "email"
    attribute_data_type = "String"
    required          = true
    mutable           = true
  }

  # 이메일을 사용한 인증 활성화
  auto_verified_attributes = ["email"]

  # 사용자 풀에 대한 기타 설정을 지정합니다.
  # 자세한 설정 옵션은 AWS 공식 문서를 참조하세요.
}

output "user_pool_id" {
  value = aws_cognito_user_pool.my_user_pool.id
}





# sqs

resource "aws_sqs_queue" "my_queue" {
  name                      = "zootopic-emailsave-queue"  # 큐의 이름을 지정합니다.
  delay_seconds             = 90          # 메시지 전달 지연 시간을 설정합니다. (옵션)
  max_message_size          = 1024        # 최대 메시지 크기를 설정합니다. (옵션)
  message_retention_seconds = 86400       # 메시지 보관 기간을 설정합니다. (옵션)
  visibility_timeout_seconds = 300        # 메시지 처리 시간 제한을 설정합니다. (옵션)
}

output "queue_url" {
  value = aws_sqs_queue.my_queue.url
}







# IAM 역할 생성
resource "aws_iam_role" "save_email_lambda_role" {
  name               = "save-email-lambda-execution-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }]
  })
}

# Amazon SES Full Access 정책을 IAM 역할에 연결
resource "aws_iam_policy_attachment" "ses_attachment" {
  name       = "ses_attachment"
  roles      = [aws_iam_role.save_email_lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

# Amazon SQS Full Access 정책을 IAM 역할에 연결
resource "aws_iam_policy_attachment" "sqs_attachment" {
  name       = "sqs_attachment"
  roles      = [aws_iam_role.save_email_lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

# AWS Lambda Full Access 정책을 IAM 역할에 연결
resource "aws_iam_policy_attachment" "lambda_attachment" {
  name       = "lambda_attachment"
  roles      = [aws_iam_role.save_email_lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

# CloudWatch Full Access 정책을 IAM 역할에 연결
resource "aws_iam_policy_attachment" "cloudwatch_attachment" {
  name       = "cloudwatch_attachment"
  roles      = [aws_iam_role.save_email_lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}







# lambda start

resource "aws_lambda_function" "save_email_lambda_function" {
  filename      = "./emailsave-0.0.1-SNAPSHOT.jar"  # 람다 함수의 코드를 포함하는 JAR 파일의 경로를 지정합니다.
  function_name = "lambda-email-saveSES"   # 람다 함수의 이름을 지정합니다.
  role          = aws_iam_role.save_email_lambda_role.arn  # 람다 함수의 실행 역할 ARN을 지정합니다.
  handler       = "ing.EmailSave::handleRequest"  # 람다 함수의 핸들러를 지정합니다.
  runtime       = "java8.al2"           # 람다 함수의 런타임 환경을 지정합니다.
}

resource "aws_lambda_permission" "sqs_invoke_permission" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.save_email_lambda_function.arn
  principal     = "sqs.amazonaws.com"

  source_arn = aws_sqs_queue.my_queue.arn
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn  = aws_sqs_queue.my_queue.arn
  function_name     = aws_lambda_function.save_email_lambda_function.arn
  batch_size        = 10  # 선택적인 옵션, 한 번에 처리할 메시지 수를 지정합니다.
}





# ses

resource "aws_ses_email_identity" "naver_email" {
  email = "mosktk9577@naver.com"  # SES에서 인증하려는 Naver 이메일 주소를 지정합니다.
}

# resource "aws_ses_email_identity_verification" "naver_email_verification" {
#   email = aws_ses_email_identity.naver_email.email  # SES에서 인증할 Naver 이메일 주소를 지정합니다.
# }




# alam

# IAM Role 정의
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}


# Amazon EventBridge Full Access 정책 연결
resource "aws_iam_policy_attachment" "sendemail_eventbridge_attachment" {
  name       = "sendemail_eventbridge_attachment"
  roles      = [aws_iam_role.lambda_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
}

# Amazon SES Full Access 정책 연결
resource "aws_iam_policy_attachment" "sendemail_ses_attachment" {
  name       = "sendemail_ses_attachment"
  roles      = [aws_iam_role.lambda_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

# AWS Lambda Full Access 정책 연결
resource "aws_iam_policy_attachment" "sendemail_lambda_full_access_attachment" {
  name       = "sendemail_lambda_full_access_attachment"
  roles      = [aws_iam_role.lambda_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

# CloudWatch Full Access 정책 연결
resource "aws_iam_policy_attachment" "sendemail_cloudwatch_attachment" {
  name       = "sendemail_cloudwatch_attachment"
  roles      = [aws_iam_role.lambda_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}



# Lambda 함수 정의
resource "aws_lambda_function" "example_lambda" {
  filename      = "./hi-0.0.1-SNAPSHOT.jar"  # Lambda 함수 코드가 포함된 ZIP 파일
  function_name = "lambda-send-email-SES"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "say.hi.App::handleRequest"
  runtime       = "java8.al2"
}

# 이벤트 브리지 규칙 정의
resource "aws_cloudwatch_event_rule" "daily_event_rule" {
  name                = "daily_event_rule"
  schedule_expression = "cron(0 6 * * ? *)"  # 매일 아침 06시에 실행
}

# Lambda 함수를 이벤트 브리지 규칙에 연결
resource "aws_cloudwatch_event_target" "target" {
  rule      = aws_cloudwatch_event_rule.daily_event_rule.name
  target_id = "example_lambda_target"
  arn       = aws_lambda_function.example_lambda.arn
}