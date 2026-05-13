##########################
# 🐍 Lambda: Accounts
##########################

resource "aws_lambda_function" "accounts" {
  function_name    = "${var.project_name}-accounts"
  runtime          = "python3.12"
  handler          = "accounts.lambda_handler"
  role             = var.lambda_role_arn
  filename         = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  timeout     = 20
  memory_size = 256

  environment {
    variables = {
      PLAID_ENV         = var.plaid_env
      PLAID_CLIENT_ID   = var.plaid_client_id
      PLAID_SECRET      = var.plaid_secret
      PLAID_ITEMS_TABLE = var.plaid_items_table
    }
  }
}
