// Config is based around running LocalStack locally with Docker:
//
// docker run -d --network host -v /var/run/docker.sock:/var/run/docker.sock localstack/localstack
//
// More info at https://www.localstack.cloud/
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  endpoints {
    s3         = "http://localhost:4566"
    dynamodb   = "http://localhost:4566"
    ec2        = "http://localhost:4566"
    sts        = "http://localhost:4566"
    iam        = "http://localhost:4566"
    lambda     = "http://localhost:4566"
    apigateway = "http://localhost:4566"
    cloudwatch = "http://localhost:4566"
    logs       = "http://localhost:4566"
  }
}
