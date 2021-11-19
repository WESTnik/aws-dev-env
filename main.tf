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
  region                  = var.aws_region[terraform.workspace]
  shared_credentials_file = var.aws_cred_file
  profile                 = "new"

}

data "archive_file" "myzip" {
  type        = "zip"
  source_file = "main.py"
  output_path = "main.zip"
}
resource "aws_lambda_function" "my_python_lambda" {
  filename         = "main.zip"
  function_name    = "my_python_lambda_${terraform.workspace}"
  source_code_hash = filebase64sha256("main.zip")
  role             = aws_iam_role.my_python_lambda_role.arn
  handler          = "main.lambda_handler"
  runtime          = "python3.8"
}

resource "aws_iam_role" "my_python_lambda_role" {
  name = "my_python_role_${terraform.workspace}"
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


resource "aws_sqs_queue" "main_queue" {
  name             = "my-main-queue_${terraform.workspace}"
  delay_seconds    = 30
  max_message_size = 262144
}


resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging"
  path = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage",
                "sqs:GetQueueAttributes",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "sqs_attachment" {
  role       = aws_iam_role.my_python_lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
