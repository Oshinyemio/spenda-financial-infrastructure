##############################
# 🐍 Total Expense Lambda Outputs
##############################

output "total_lambda_name" {
  description = "Name of the total Expense Lambda function"
  value       = aws_lambda_function.total.function_name
}

output "total_lambda_arn" {
  description = "ARN of the total Expense Lambda function"
  value       = aws_lambda_function.total.arn
}
