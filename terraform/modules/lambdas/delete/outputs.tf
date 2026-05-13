##############################
# 🐍 Delete Expense Lambda Outputs
##############################

output "delete_lambda_name" {
  description = "Name of the Delete Expense Lambda function"
  value       = aws_lambda_function.delete.function_name
}

output "delete_lambda_arn" {
  description = "ARN of the Delete Expense Lambda function"
  value       = aws_lambda_function.delete.arn
}
