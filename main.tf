terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.65.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region                  = var.aws_region
  shared_credentials_file = var.aws_cred_file
  profile                 = "new"

}

data "archive_file" "myzip" {
  type        = "zip"
  source_file = "main.py"
  output_path = "main.zip"
}
resource "aws_lambda_function" "my_python_lambda" {
  filename      = "main.zip"
  function_name = "my_python_lambda_test"
  role          = aws_iam_role.my_python_lambda_role.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.8"
}

resource "aws_iam_role" "my_python_lambda_role" {
  name = "my_python_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}
