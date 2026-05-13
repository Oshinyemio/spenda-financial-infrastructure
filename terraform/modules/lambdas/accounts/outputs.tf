##############################
# 🐍 Plaid Accounts Lambda Outputs
##############################

output "accounts_lambda_name" {
  description = "Name of the Plaid Accounts Lambda function"
  value       = aws_lambda_function.accounts.function_name
}

output "accounts_lambda_arn" {
  description = "ARN of the Plaid Accounts Lambda function"
  value       = aws_lambda_function.accounts.arn
}

output "accounts_lambda_invoke_arn" {
  description = "Invoke ARN of the Accounts Lambda function"
  value       = aws_lambda_function.accounts.arn
}