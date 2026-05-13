##########################
# 🐍 Lambda: Delete Expense
##########################

resource "aws_lambda_function" "delete" {
  function_name    = "${var.project_name}-delete"
  runtime          = "python3.12" # Ensure this matches your other lambdas
  handler          = "delete.lambda_handler"
  role             = var.lambda_role_arn
  filename         = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  environment {
    variables = {
      DYNAMODB_TABLE      = var.dynamodb_table
      METADATA_TABLE      = var.meta_table_name
      EXPENSE_DATA_BUCKET = var.s3_bucket_name # Needed for S3 audit log
    }
  }

  tags = {
    Project = var.project_name
  }
}