#################################
# 📤 Transactions Lambda Outputs
#################################

output "transactions_lambda_name" {
  value = aws_lambda_function.transactions.function_name
}

output "transactions_lambda_arn" {
  value = aws_lambda_function.transactions.arn
}

output "transactions_lambda_invoke_arn" {
  value = aws_lambda_function.transactions.arn
}
