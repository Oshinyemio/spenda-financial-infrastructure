resource "aws_lambda_function" "meta" {
  function_name    = "${var.project_name}-meta"
  runtime          = "python3.12"
  handler          = "meta.lambda_handler"
  role             = var.lambda_role_arn
  filename         = var.lambda_zip_path    # reuse the same variable here
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  environment {
    variables = {
      METADATA_TABLE = var.meta_table_name
      METADATA_PARTITION_KEY  = "accountId"
      METADATA_SORT_KEY       = "metaKey"
    }
  }

  tags = {
    Project = var.project_name
  }
}
