##############################
# 🐍 Edit Expense Lambda Outputs
##############################

output "edit_lambda_name" {
  description = "Name of the Add Expense Lambda function"
  value       = aws_lambda_function.edit.function_name
}

output "edit_lambda_arn" {
  description = "ARN of the Add Expense Lambda function"
  value       = aws_lambda_function.edit.arn
}