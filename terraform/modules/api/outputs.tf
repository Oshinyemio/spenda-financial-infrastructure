########################
# 📤 API Module Outputs
########################

# 🔗 Root REST API ID (used in other modules)
output "rest_api_id" {
  value = aws_api_gateway_rest_api.et_api.id
}

# 🏷️ Deployed Stage Name (usually "prod")
output "stage_name" {
  value = aws_api_gateway_stage.prod.stage_name
}

# 🌐 Full Invoke URL for API Gateway
output "api_invoke_url" {
  description = "Invoke URL for the API Gateway"
  value = format(
    "https://%s.execute-api.%s.amazonaws.com/%s",
    aws_api_gateway_rest_api.et_api.id,
    var.aws_region,
    var.stage_name
  )
}

########################
# ⚙️ Lambda Invoke ARNs
########################

# ➕ Add Expense Lambda
output "add_lambda_invoke_arn" {
  value = var.add_lambda_invoke_arn
}

# 📥 Get Expense Lambda
output "get_lambda_invoke_arn" {
  value = var.get_lambda_invoke_arn
}

# 🗄️ Export Expense Lambda
output "export_lambda_invoke_arn" {
  value = var.export_lambda_invoke_arn
}

# 📝 Metadata Lambda
output "meta_lambda_invoke_arn" {
  value = var.meta_lambda_invoke_arn
}

# ✏️ Edit Expense Lambda
output "edit_lambda_invoke_arn" {
  value = var.edit_lambda_invoke_arn
}

# 🗑️ Delete Expense Lambda
output "delete_lambda_invoke_arn" {
  value = var.delete_lambda_invoke_arn
}

# 💰 Total Expense Lambda
output "total_lambda_invoke_arn" {
  value = var.total_lambda_invoke_arn
}

# 🔗 Link Lambda
output "link_lambda_invoke_arn" {
  value = var.link_lambda_invoke_arn
}

# 🔁 Exchange Lambda
output "exchange_lambda_invoke_arn" {
  value = var.exchange_lambda_invoke_arn
}

# 🧾 Accounts Lambda
output "accounts_lambda_invoke_arn" {
  value = var.accounts_lambda_invoke_arn
}

########################
# 🗂️ API Resource IDs (for CORS modules)
########################

output "add_resource_id" {
  value = aws_api_gateway_resource.add.id
}

output "get_resource_id" {
  value = aws_api_gateway_resource.get.id
}

output "export_resource_id" {
  value = aws_api_gateway_resource.export.id
}

output "meta_resource_id" {
  value = aws_api_gateway_resource.meta.id
}

output "edit_resource_id" {
  value = aws_api_gateway_resource.edit.id
}

output "delete_resource_id" {
  value = aws_api_gateway_resource.delete.id
}

output "total_resource_id" {
  value = aws_api_gateway_resource.total.id
}

output "link_resource_id" {
  value = aws_api_gateway_resource.link.id
}

output "exchange_resource_id" {
  value = aws_api_gateway_resource.exchange.id
}

output "accounts_resource_id" {
  value = aws_api_gateway_resource.accounts.id
}

# Transactions resources
output "transactions_sync_resource_id" {
  value = aws_api_gateway_resource.transactions_sync.id
}

output "transactions_list_resource_id" {
  value = aws_api_gateway_resource.transactions_list.id
}

output "transactions_get_resource_id" {
  value = aws_api_gateway_resource.transactions_get.id
}

output "transactions_status_resource_id" {
  value = aws_api_gateway_resource.transactions_status.id
}

# Balance resources
output "balance_resource_id" {
  value = aws_api_gateway_resource.balance.id
}
