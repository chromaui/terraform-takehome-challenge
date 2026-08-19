// API Gateway that will make our build ID Lambda available
// for consumption
resource "aws_apigatewayv2_api" "important_api" {
  name          = "staging-rest-api"
  description   = "Staging API Gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id                 = aws_apigatewayv2_api.important_api.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.api_lambda.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "proxy" {
  api_id    = aws_apigatewayv2_api.important_api.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_route" "proxy_root" {
  api_id    = aws_apigatewayv2_api.important_api.id
  route_key = "ANY /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_stage" "deployment" {
  api_id      = aws_apigatewayv2_api.important_api.id
  name        = var.api-stage
  auto_deploy = true

  default_route_settings {
    logging_level            = "INFO"
    detailed_metrics_enabled = true
  }
}
