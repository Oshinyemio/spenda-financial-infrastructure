##########################
# 🐍 Lambda: Add Expense
##########################

resource "aws_lambda_function" "add" {
  function_name    = "${var.project_name}-add"
  runtime          = "python3.12"
  handler          = "add.lambda_handler"
  role 		         = var.lambda_role_arn
  filename         = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  environment {
    variables = {
      DYNAMODB_TABLE      = var.dynamodb_table
      METADATA_TABLE          = var.meta_table_name
      EXPENSE_DATA_BUCKET = var.s3_bucket_name
    }
  }

  tags = {
    Project = var.project_name
  }
}
