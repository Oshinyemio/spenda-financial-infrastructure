##############################
# 📤 Get meta Lambda Outputs
##############################

output "meta_lambda_name" {
  description = "Name of the meta Lambda function"
  value       = aws_lambda_function.meta.function_name
}

output "meta_lambda_arn" {
  description = "ARN of the meta Lambda function"
  value       = aws_lambda_function.meta.arn
}
