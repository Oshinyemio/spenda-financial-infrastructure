###############################
# 📤 Export Expense Lambda Outputs
###############################

# 🏷️ Export Expense Lambda function name
output "export_lambda_name" {
  value = aws_lambda_function.export.function_name
}

# 🔗 Export Expense Lambda function ARN
output "export_lambda_arn" {
  value = aws_lambda_function.export.arn
}
