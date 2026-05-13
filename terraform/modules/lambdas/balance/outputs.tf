#################################
# 📤 Balance Lambda Outputs
#################################

output "balance_lambda_name" {
  value = aws_lambda_function.balance.function_name
}

output "balance_lambda_arn" {
  value = aws_lambda_function.balance.arn
}

output "balance_lambda_invoke_arn" {
  value = aws_lambda_function.balance.arn
}
