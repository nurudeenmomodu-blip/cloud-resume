terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}
resource "aws_dynamodb_table" "resume_stats" {
  name         = "cloud-resume-stats"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
# 1. Lambda Function Configuration Code Block
resource "aws_lambda_function" "resume_counter" {
  function_name = "cloud-resume-counter"
  runtime       = "python3.12"
  handler       = "lambda_function.lambda_handler"
  role          = "arn:aws:iam::713362556950:role/cloud-resume-counter-role-asn18uyn"
  filename      = "lambda_function.zip" # We will map this file structure next
}

# 2. API Gateway Traffic Control Interface Block
resource "aws_apigatewayv2_api" "resume_api" {
  name          = "resume-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.resume_api.id
  name        = "$default"
  auto_deploy = true
}
