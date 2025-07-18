// Lambda config for the new build ID generator
// An 'npm install' should be done in the ./code
// directory before running an apply
//
// Lots of boilerplate here, maybe use the AWS
// managed Terraform module?
// https://github.com/terraform-aws-modules/terraform-aws-lambda
data "aws_iam_policy_document" "lambda_trust_policy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = format("%s/*/*", aws_api_gateway_rest_api.important_api.execution_arn)
}

resource "aws_default_security_group" "lambda_security_group" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "staging-lambda-security-group"
  }
}

resource "aws_iam_role" "lambda_iam_role" {
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_policy.json
  name               = "staging-iam-role-lambda-trigger"
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access_execution" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "archive_file" "lambda_function_code" {
  type        = "zip"
  source_dir  = "./code"
  output_path = "./build/lambda_function.zip"
}

resource "aws_lambda_function" "api_lambda" {
  function_name    = "staging-lambda"
  role             = aws_iam_role.lambda_iam_role.arn
  handler          = "index.handler"
  filename         = data.archive_file.lambda_function_code.output_path
  source_code_hash = data.archive_file.lambda_function_code.output_base64sha256
  runtime          = "nodejs20.x"
  vpc_config {
    subnet_ids         = [aws_subnet.private[0].id]
    security_group_ids = [aws_default_security_group.lambda_security_group.id]
  }
  logging_config {
    log_group  = aws_cloudwatch_log_group.important_lambda.name
    log_format = "Text"
  }
}
