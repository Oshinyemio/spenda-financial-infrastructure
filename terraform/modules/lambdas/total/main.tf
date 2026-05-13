##########################
# 🐍 Lambda: Total Expense
##########################

resource "aws_lambda_function" "total" {
  function_name    = "${var.project_name}-total"
  runtime          = "python3.12"
  handler          = "total.lambda_handler"
  role 		         = var.lambda_role_arn
  filename         = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  environment {
    variables = {
      DYNAMODB_TABLE      = var.dynamodb_table
      METADATA_TABLE      = var.meta_table_name
    }
  }

  tags = {
    Project = var.project_name
  }
}
