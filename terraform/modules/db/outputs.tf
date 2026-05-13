###############################
# 🗄️ DynamoDB Module Outputs
###############################

# 🏷️ Name of the DynamoDB expense table
output "table_name" {
  value = aws_dynamodb_table.expense_table.name
}

# 🛡️ ARN of the DynamoDB expense table
output "table_arn" {
  value = aws_dynamodb_table.expense_table.arn
}

# 🏷️ Name of the DynamoDB metadata table
output "meta_table_name" {
  value = aws_dynamodb_table.meta_table.name
}

# 🛡️ ARN of the DynamoDB metadata table
output "meta_table_arn" {
  description = "ARN of the meta DynamoDB table"
  value       = aws_dynamodb_table.meta_table.arn
}

#################################
# 🗄️ DynamoDB Plaid Items Table Outputs
#################################

# 🏷️ Name of the DynamoDB Plaid items table
output "plaid_items_table_name" {
  value       = aws_dynamodb_table.plaid_items_table.name
  description = "Plaid items DynamoDB table name"
}

# 🛡️ ARN of the DynamoDB Plaid items table
output "plaid_items_table_arn" {
  value       = aws_dynamodb_table.plaid_items_table.arn
  description = "Plaid items DynamoDB table ARN"
}

# 🏷️ Name of the DynamoDB Plaid transactions table
output "plaid_transactions_table_name" {
  value       = aws_dynamodb_table.plaid_transactions_table.name
  description = "Plaid transactions DynamoDB table name"
}

# 🛡️ ARN of the DynamoDB Plaid transactions table
output "plaid_transactions_table_arn" {
  value       = aws_dynamodb_table.plaid_transactions_table.arn
  description = "Plaid transactions DynamoDB table ARN"
}

# 🏷️ Name of the DynamoDB Plaid sync cursor table
output "plaid_cursors_table_name" {
  value       = aws_dynamodb_table.plaid_cursors_table.name
  description = "Plaid sync cursor DynamoDB table name"
}

# 🛡️ ARN of the DynamoDB Plaid sync cursor table
output "plaid_cursors_table_arn" {
  value       = aws_dynamodb_table.plaid_cursors_table.arn
  description = "Plaid sync cursor DynamoDB table ARN"
}