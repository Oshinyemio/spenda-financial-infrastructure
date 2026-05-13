#################################
# 🐍 Balance Lambda Function
#################################

resource "aws_lambda_function" "balance" {
  function_name = "${var.project_name}-balance"
  handler       = "balance.lambda_handler"
  runtime       = "python3.12"
  role          = var.lambda_role_arn

  filename         = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  timeout     = 25
  memory_size = 256
  layers      = var.layers

  environment {
    variables = {
      PLAID_CLIENT_ID   = var.plaid_client_id
      PLAID_SECRET      = var.plaid_secret
      PLAID_ENV         = var.plaid_env
      PLAID_ITEMS_TABLE = var.plaid_items_table
    }
  }
}
