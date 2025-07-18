resource "aws_cloudwatch_log_group" "important_lambda" {
  name = "/aws/lambda/staging-api"
  tags = {
    "Environment" = "staging"
    "Service"     = "important-api-lambda"
  }
}
