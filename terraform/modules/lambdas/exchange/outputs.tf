#################################
# 📤 Exchange Lambda Outputs
#################################

output "exchange_lambda_name" {
  value = aws_lambda_function.exchange.function_name
}

output "exchange_lambda_arn" {
  value = aws_lambda_function.exchange.arn
}

output "exchange_lambda_invoke_arn" {
  value = aws_lambda_function.exchange.arn
}