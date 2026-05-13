#################################
# 📤 Link Lambda Outputs
#################################

output "link_lambda_name" {
  value = aws_lambda_function.link.function_name
}

output "link_lambda_arn" {
  value = aws_lambda_function.link.arn
}

output "link_lambda_invoke_arn" {
  value = aws_lambda_function.link.arn
}