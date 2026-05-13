#################################
# 📤 Plaid Layer Outputs
#################################

output "plaid_layer_arn" {
  value = aws_lambda_layer_version.plaid_layer.arn
}
