#################################
# 🐍 Plaid Link Lambda Function
#################################

resource "aws_lambda_function" "link" {
  function_name = "${var.project_name}-link"
  role          = var.lambda_role_arn
  handler       = "link.lambda_handler"
  runtime       = "python3.12"
  filename      = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  timeout = 15

  layers = var.layers

  environment {
    variables = {
      PLAID_CLIENT_ID    = var.plaid_client_id
      PLAID_SECRET       = var.plaid_secret
      PLAID_ENV          = var.plaid_env
    }
  }

  tags = {
    Project = var.project_name
  }
}
