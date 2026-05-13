##############################
# 🐍 Add Expense Lambda Outputs
##############################

output "add_lambda_name" {
  description = "Name of the Add Expense Lambda function"
  value       = aws_lambda_function.add.function_name
}

output "add_lambda_arn" {
  description = "ARN of the Add Expense Lambda function"
  value       = aws_lambda_function.add.arn
}
