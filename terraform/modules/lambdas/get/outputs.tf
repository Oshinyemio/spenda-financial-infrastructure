##############################
# 📤 Get Expense Lambda Outputs
##############################

output "get_lambda_name" {
  description = "Name of the Get Expense Lambda function"
  value       = aws_lambda_function.get.function_name
}

output "get_lambda_arn" {
  description = "ARN of the Get Expense Lambda function"
  value       = aws_lambda_function.get.arn
}
