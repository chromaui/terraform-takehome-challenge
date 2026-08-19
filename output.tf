output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "api_url" {
  description = "URL that can access the API Gateway REST endpoint"
  value       = format("http://localhost:4566/_aws/execute-api/%s/%s", aws_apigatewayv2_api.important_api.id, var.api-stage)
}

output "api_id" {
  description = "ID of the API Gateway instance"
  value       = aws_apigatewayv2_api.important_api.id
}
