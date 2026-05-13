# api/main.tf

######################################
# 🚪 API Gateway: Expense Tracker API
######################################

resource "aws_api_gateway_rest_api" "et_api" {
  name        = "${var.project_name}-api"
  description = "Unified API Gateway for Expense Tracker"
}

###########################
# 👤 Cognito Authorizer
###########################

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name            = "cognito-authorizer"
  rest_api_id     = aws_api_gateway_rest_api.et_api.id
  identity_source = "method.request.header.Authorization"
  type            = "COGNITO_USER_POOLS"
  provider_arns   = [var.cognito_user_pool_arn]
}

#########################################################
# 🌐 API Endpoints (Resources, Methods, and Integrations)
#########################################################

# --- Resource: /add ---
resource "aws_api_gateway_resource" "add" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  parent_id   = aws_api_gateway_rest_api.et_api.root_resource_id
  path_part   = "add"
}

resource "aws_api_gateway_method" "add_post" {
  rest_api_id   = aws_api_gateway_rest_api.et_api.id
  resource_id   = aws_api_gateway_resource.add.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "add_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.et_api.id
  resource_id             = aws_api_gateway_resource.add.id
  http_method             = aws_api_gateway_method.add_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  # Using add_lambda_invoke_arn which will receive add_lambda_arn from root/main.tf
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.add_lambda_invoke_arn}/invocations"
  depends_on              = [aws_lambda_permission.allow_api_gateway_invoke_add]
}

# --- Resource: /get ---
resource "aws_api_gateway_resource" "get" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  parent_id   = aws_api_gateway_rest_api.et_api.root_resource_id
  path_part   = "get"
}

resource "aws_api_gateway_method" "get_get" {
  rest_api_id   = aws_api_gateway_rest_api.et_api.id
  resource_id   = aws_api_gateway_resource.get.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "get_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.et_api.id
  resource_id             = aws_api_gateway_resource.get.id
  http_method             = aws_api_gateway_method.get_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  # Using get_lambda_invoke_arn which will receive get_lambda_arn from root/main.tf
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.get_lambda_invoke_arn}/invocations"
  depends_on              = [aws_lambda_permission.allow_api_gateway_invoke_get]
}

# --- Resource: /export ---
resource "aws_api_gateway_resource" "export" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  parent_id   = aws_api_gateway_rest_api.et_api.root_resource_id
  path_part   = "export"
}

resource "aws_api_gateway_method" "export_get" {
  rest_api_id   = aws_api_gateway_rest_api.et_api.id
  resource_id   = aws_api_gateway_resource.export.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "export_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.et_api.id
  resource_id             = aws_api_gateway_resource.export.id
  http_method             = aws_api_gateway_method.export_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  # Using export_lambda_invoke_arn which will receive export_lambda_arn from root/main.tf
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.export_lambda_invoke_arn}/invocations"
  depends_on              = [aws_lambda_permission.allow_api_gateway_invoke_export]
}

# --- Resource: /meta ---
resource "aws_api_gateway_resource" "meta" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  parent_id   = aws_api_gateway_rest_api.et_api.root_resource_id
  path_part   = "meta"
}

resource "aws_api_gateway_method" "meta_get" {
  rest_api_id   = aws_api_gateway_rest_api.et_api.id
  resource_id   = aws_api_gateway_resource.meta.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "meta_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.et_api.id
  resource_id             = aws_api_gateway_resource.meta.id
  http_method             = aws_api_gateway_method.meta_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  # Using meta_lambda_invoke_arn which will receive meta_lambda_arn from root/main.tf
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.meta_lambda_invoke_arn}/invocations"
  depends_on              = [aws_lambda_permission.allow_api_gateway_invoke_meta]
}

resource "aws_api_gateway_method" "meta_post" {
  rest_api_id   = aws_api_gateway_rest_api.et_api.id
  resource_id   = aws_api_gateway_resource.meta.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "meta_post_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.et_api.id
  resource_id             = aws_api_gateway_resource.meta.id
  http_method             = aws_api_gateway_method.meta_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  # Using meta_lambda_invoke_arn which will receive meta_lambda_arn from root/main.tf
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.meta_lambda_invoke_arn}/invocations"
  depends_on              = [aws_lambda_permission.allow_api_gateway_invoke_meta_post]
}

# --- Resource: /edit ---
resource "aws_api_gateway_resource" "edit" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  parent_id   = aws_api_gateway_rest_api.et_api.root_resource_id
  path_part   = "edit"
}

resource "aws_api_gateway_method" "edit_post" {
  rest_api_id   = aws_api_gateway_rest_api.et_api.id
  resource_id   = aws_api_gateway_resource.edit.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "edit_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.et_api.id
  resource_id             = aws_api_gateway_resource.edit.id
  http_method             = aws_api_gateway_method.edit_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  # Using edit_lambda_invoke_arn which will receive edit_lambda_arn from root/main.tf
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.edit_lambda_invoke_arn}/invocations"
  depends_on              = [aws_lambda_permission.allow_api_gateway_invoke_edit]
}

# --- Resource: /delete ---
resource "aws_api_gateway_resource" "delete" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  parent_id   = aws_api_gateway_rest_api.et_api.root_resource_id
  path_part   = "delete"
}

resource "aws_api_gateway_method" "delete_post" {
  rest_api_id   = aws_api_gateway_rest_api.et_api.id
  resource_id   = aws_api_gateway_resource.delete.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "delete_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.et_api.id
  resource_id             = aws_api_gateway_resource.delete.id
  http_method             = aws_api_gateway_method.delete_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  # Using delete_lambda_invoke_arn which will receive delete_lambda_arn from root/main.tf
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.delete_lambda_invoke_arn}/invocations"
  depends_on              = [aws_lambda_permission.allow_api_gateway_invoke_delete]
}

# --- Resource: /total ---
resource "aws_api_gateway_resource" "total" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  parent_id   = aws_api_gateway_rest_api.et_api.root_resource_id
  path_part   = "total"
}

resource "aws_api_gateway_method" "total_get" {
  rest_api_id   = aws_api_gateway_rest_api.et_api.id
  resource_id   = aws_api_gateway_resource.total.id
  http_method   = "GET" # total.py uses GET
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "total_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.et_api.id
  resource_id             = aws_api_gateway_resource.total.id
  http_method             = aws_api_gateway_method.total_get.http_method
  integration_http_method = "POST" # Lambda always invoked via POST by API Gateway
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.total_lambda_invoke_arn}/invocations"
  depends_on              = [aws_lambda_permission.allow_api_gateway_invoke_total]
}

# --- Resource: /link ---
resource "aws_api_gateway_resource" "link" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  parent_id   = aws_api_gateway_rest_api.et_api.root_resource_id
  path_part   = "link"
}

resource "aws_api_gateway_method" "link_post" {
  rest_api_id   = aws_api_gateway_rest_api.et_api.id
  resource_id   = aws_api_gateway_resource.link.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "link_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.et_api.id
  resource_id             = aws_api_gateway_resource.link.id
  http_method             = aws_api_gateway_method.link_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.link_lambda_invoke_arn}/invocations"
  depends_on              = [aws_lambda_permission.allow_api_gateway_invoke_link]
}

# --- Resource: /exchange ---
resource "aws_api_gateway_resource" "exchange" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  parent_id   = aws_api_gateway_rest_api.et_api.root_resource_id
  path_part   = "exchange"
}

resource "aws_api_gateway_method" "exchange_post" {
  rest_api_id   = aws_api_gateway_rest_api.et_api.id
  resource_id   = aws_api_gateway_resource.exchange.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "exchange_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.et_api.id
  resource_id             = aws_api_gateway_resource.exchange.id
  http_method             = aws_api_gateway_method.exchange_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.exchange_lambda_invoke_arn}/invocations"
  depends_on              = [aws_lambda_permission.allow_api_gateway_invoke_exchange]
}

# --- Resource: /accounts ---
resource "aws_api_gateway_resource" "accounts" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  parent_id   = aws_api_gateway_rest_api.et_api.root_resource_id
  path_part   = "accounts"
}

resource "aws_api_gateway_method" "accounts_get" {
  rest_api_id   = aws_api_gateway_rest_api.et_api.id
  resource_id   = aws_api_gateway_resource.accounts.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "accounts_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.et_api.id
  resource_id             = aws_api_gateway_resource.accounts.id
  http_method             = aws_api_gateway_method.accounts_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.accounts_lambda_invoke_arn}/invocations"
  depends_on              = [aws_lambda_permission.allow_api_gateway_invoke_accounts]
}

# --- Resource: /transactions ---
resource "aws_api_gateway_resource" "transactions" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  parent_id   = aws_api_gateway_rest_api.et_api.root_resource_id
  path_part   = "transactions"
}


# --- Resource: /transactions/sync ---
resource "aws_api_gateway_resource" "transactions_sync" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  parent_id   = aws_api_gateway_resource.transactions.id
  path_part   = "sync"
}

resource "aws_api_gateway_method" "transactions_sync_post" {
  rest_api_id   = aws_api_gateway_rest_api.et_api.id
  resource_id   = aws_api_gateway_resource.transactions_sync.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "transactions_sync_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.et_api.id
  resource_id             = aws_api_gateway_resource.transactions_sync.id
  http_method             = aws_api_gateway_method.transactions_sync_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.transactions_lambda_invoke_arn}/invocations"
  depends_on              = [aws_lambda_permission.allow_api_gateway_invoke_transactions_sync]
}

resource "aws_api_gateway_resource" "transactions_list" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  parent_id   = aws_api_gateway_resource.transactions.id
  path_part   = "list"
}

resource "aws_api_gateway_method" "transactions_list_post" {
  rest_api_id   = aws_api_gateway_rest_api.et_api.id
  resource_id   = aws_api_gateway_resource.transactions_list.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "transactions_list_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.et_api.id
  resource_id             = aws_api_gateway_resource.transactions_list.id
  http_method             = aws_api_gateway_method.transactions_list_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.transactions_lambda_invoke_arn}/invocations"
}

resource "aws_api_gateway_resource" "transactions_get" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  parent_id   = aws_api_gateway_resource.transactions.id
  path_part   = "get"
}

resource "aws_api_gateway_method" "transactions_get_post" {
  rest_api_id   = aws_api_gateway_rest_api.et_api.id
  resource_id   = aws_api_gateway_resource.transactions_get.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "transactions_get_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.et_api.id
  resource_id             = aws_api_gateway_resource.transactions_get.id
  http_method             = aws_api_gateway_method.transactions_get_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.transactions_lambda_invoke_arn}/invocations"
}

resource "aws_api_gateway_resource" "transactions_status" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  parent_id   = aws_api_gateway_resource.transactions.id
  path_part   = "status"
}

resource "aws_api_gateway_method" "transactions_status_post" {
  rest_api_id   = aws_api_gateway_rest_api.et_api.id
  resource_id   = aws_api_gateway_resource.transactions_status.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "transactions_status_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.et_api.id
  resource_id             = aws_api_gateway_resource.transactions_status.id
  http_method             = aws_api_gateway_method.transactions_status_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.transactions_lambda_invoke_arn}/invocations"
}

# --- Resource: /balance ---
resource "aws_api_gateway_resource" "balance" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  parent_id   = aws_api_gateway_rest_api.et_api.root_resource_id
  path_part   = "balance"
}

resource "aws_api_gateway_method" "balance_get" {
  rest_api_id   = aws_api_gateway_rest_api.et_api.id
  resource_id   = aws_api_gateway_resource.balance.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "balance_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.et_api.id
  resource_id             = aws_api_gateway_resource.balance.id
  http_method             = aws_api_gateway_method.balance_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.balance_lambda_invoke_arn}/invocations"
  depends_on              = [aws_lambda_permission.allow_api_gateway_invoke_balance]
}

#####################################
# 🛡️ Lambda Permissions
#####################################

resource "aws_lambda_permission" "allow_api_gateway_invoke_add" {
  statement_id  = "AllowAPIGatewayInvokeAdd"
  action        = "lambda:InvokeFunction"
  function_name = var.add_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.et_api.id}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_get" {
  statement_id  = "AllowAPIGatewayInvokeGet"
  action        = "lambda:InvokeFunction"
  function_name = var.get_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.et_api.id}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_export" {
  statement_id  = "AllowAPIGatewayInvokeExport"
  action        = "lambda:InvokeFunction"
  function_name = var.export_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.et_api.id}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_meta" {
  statement_id  = "AllowAPIGatewayInvokeMeta"
  action        = "lambda:InvokeFunction"
  function_name = var.meta_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.et_api.id}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_meta_post" {
  statement_id  = "AllowAPIGatewayInvokeMetaPost"
  action        = "lambda:InvokeFunction"
  function_name = var.meta_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.et_api.id}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_edit" {
  statement_id  = "AllowAPIGatewayInvokeEdit"
  action        = "lambda:InvokeFunction"
  function_name = var.edit_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.et_api.id}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_delete" {
  statement_id  = "AllowAPIGatewayInvokeDelete"
  action        = "lambda:InvokeFunction"
  function_name = var.delete_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.et_api.id}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_total" {
  statement_id  = "AllowAPIGatewayInvokeTotal"
  action        = "lambda:InvokeFunction"
  function_name = var.total_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.et_api.id}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_link" {
  statement_id  = "AllowAPIGatewayInvokeLink"
  action        = "lambda:InvokeFunction"
  function_name = var.link_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.et_api.id}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_exchange" {
  statement_id  = "AllowAPIGatewayInvokeExchange"
  action        = "lambda:InvokeFunction"
  function_name = var.exchange_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.et_api.id}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_accounts" {
  statement_id  = "AllowAPIGatewayInvokeAccounts"
  action        = "lambda:InvokeFunction"
  function_name = var.accounts_lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.et_api.id}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_transactions_sync" {
  statement_id  = "AllowAPIGatewayInvokeTransactionsSync"
  action        = "lambda:InvokeFunction"
  function_name = var.transactions_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.et_api.id}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_transactions_list" {
  statement_id  = "AllowAPIGatewayInvokeTransactionsList"
  action        = "lambda:InvokeFunction"
  function_name = var.transactions_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.et_api.id}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_transactions_get" {
  statement_id  = "AllowAPIGatewayInvokeTransactionsGet"
  action        = "lambda:InvokeFunction"
  function_name = var.transactions_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.et_api.id}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_balance" {
  statement_id  = "AllowAPIGatewayInvokeBalance"
  action        = "lambda:InvokeFunction"
  function_name = var.balance_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.et_api.id}/*/*"
}

#########################################################
# 🌐 API Method & Integration Responses (for CORS Headers)
#########################################################

# --- Add POST Method Responses ---
resource "aws_api_gateway_method_response" "add_post_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.add.id
  http_method = aws_api_gateway_method.add_post.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "add_post_integration_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.add.id
  http_method = aws_api_gateway_method.add_post.http_method
  status_code = "200"
  depends_on = [
    aws_api_gateway_integration.add_lambda,
    aws_api_gateway_method_response.add_post_200_response
  ]
  selection_pattern = ""
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

# --- Get GET Method Responses ---
resource "aws_api_gateway_method_response" "get_get_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.get.id
  http_method = aws_api_gateway_method.get_get.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "get_get_integration_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.get.id
  http_method = aws_api_gateway_method.get_get.http_method
  status_code = "200"
  depends_on = [
    aws_api_gateway_integration.get_lambda,
    aws_api_gateway_method_response.get_get_200_response
  ]
  selection_pattern = ""
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

# --- Export GET Method Responses ---
resource "aws_api_gateway_method_response" "export_get_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.export.id
  http_method = aws_api_gateway_method.export_get.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "export_get_integration_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.export.id
  http_method = aws_api_gateway_method.export_get.http_method
  status_code = "200"
  depends_on = [
    aws_api_gateway_integration.export_lambda,
    aws_api_gateway_method_response.export_get_200_response
  ]
  selection_pattern = ""
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

# --- Meta GET Method Responses ---
resource "aws_api_gateway_method_response" "meta_get_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.meta.id
  http_method = aws_api_gateway_method.meta_get.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_method_response" "meta_get_400_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.meta.id
  http_method = aws_api_gateway_method.meta_get.http_method
  status_code = "400"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "meta_get_integration_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.meta.id
  http_method = aws_api_gateway_method.meta_get.http_method
  status_code = "200"
  depends_on = [
    aws_api_gateway_integration.meta_lambda,
    aws_api_gateway_method_response.meta_get_200_response
  ]
  selection_pattern = ""
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

resource "aws_api_gateway_integration_response" "meta_get_integration_400_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.meta.id
  http_method = aws_api_gateway_method.meta_get.http_method
  status_code = "400"
  depends_on = [
    aws_api_gateway_integration.meta_lambda,
    aws_api_gateway_method_response.meta_get_400_response
  ]
  selection_pattern = ".*statusCode\":400.*"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

# --- Meta POST Method Responses ---
resource "aws_api_gateway_method_response" "meta_post_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.meta.id
  http_method = aws_api_gateway_method.meta_post.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "meta_post_integration_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.meta.id
  http_method = aws_api_gateway_method.meta_post.http_method
  status_code = "200"
  depends_on = [
    aws_api_gateway_integration.meta_post_lambda,
    aws_api_gateway_method_response.meta_post_200_response
  ]
  selection_pattern = ""
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

# --- Edit POST Method Responses ---
resource "aws_api_gateway_method_response" "edit_post_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.edit.id
  http_method = aws_api_gateway_method.edit_post.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "edit_post_integration_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.edit.id
  http_method = aws_api_gateway_method.edit_post.http_method
  status_code = "200"
  depends_on = [
    aws_api_gateway_integration.edit_lambda,
    aws_api_gateway_method_response.edit_post_200_response
  ]
  selection_pattern = ""
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

resource "aws_api_gateway_method_response" "edit_post_400_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.edit.id
  http_method = aws_api_gateway_method.edit_post.http_method
  status_code = "400"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "edit_post_integration_400_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.edit.id
  http_method = aws_api_gateway_method.edit_post.http_method
  status_code = "400"
  depends_on = [
    aws_api_gateway_integration.edit_lambda,
    aws_api_gateway_method_response.edit_post_400_response
  ]
  selection_pattern = ".*statusCode\":400.*"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

resource "aws_api_gateway_method_response" "edit_post_403_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.edit.id
  http_method = aws_api_gateway_method.edit_post.http_method
  status_code = "403"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "edit_post_integration_403_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.edit.id
  http_method = aws_api_gateway_method.edit_post.http_method
  status_code = "403"
  depends_on = [
    aws_api_gateway_integration.edit_lambda,
    aws_api_gateway_method_response.edit_post_403_response
  ]
  selection_pattern = ".*statusCode\":403.*"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

resource "aws_api_gateway_method_response" "edit_post_404_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.edit.id
  http_method = aws_api_gateway_method.edit_post.http_method
  status_code = "404"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "edit_post_integration_404_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.edit.id
  http_method = aws_api_gateway_method.edit_post.http_method
  status_code = "404"
  depends_on = [
    aws_api_gateway_integration.edit_lambda,
    aws_api_gateway_method_response.edit_post_404_response
  ]
  selection_pattern = ".*statusCode\":404.*"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

resource "aws_api_gateway_method_response" "edit_post_500_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.edit.id
  http_method = aws_api_gateway_method.edit_post.http_method
  status_code = "500"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "edit_post_integration_500_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.edit.id
  http_method = aws_api_gateway_method.edit_post.http_method
  status_code = "500"
  depends_on = [
    aws_api_gateway_integration.edit_lambda,
    aws_api_gateway_method_response.edit_post_500_response
  ]
  selection_pattern = ".*statusCode\":500.*"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

# --- Delete POST Method Responses ---
resource "aws_api_gateway_method_response" "delete_post_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.delete.id
  http_method = aws_api_gateway_method.delete_post.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "delete_post_integration_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.delete.id
  http_method = aws_api_gateway_method.delete_post.http_method
  status_code = "200"
  depends_on = [
    aws_api_gateway_integration.delete_lambda,
    aws_api_gateway_method_response.delete_post_200_response
  ]
  selection_pattern = ""
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

resource "aws_api_gateway_method_response" "delete_post_400_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.delete.id
  http_method = aws_api_gateway_method.delete_post.http_method
  status_code = "400"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "delete_post_integration_400_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.delete.id
  http_method = aws_api_gateway_method.delete_post.http_method
  status_code = "400"
  depends_on = [
    aws_api_gateway_integration.delete_lambda,
    aws_api_gateway_method_response.delete_post_400_response
  ]
  selection_pattern = ".*statusCode\":400.*"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

resource "aws_api_gateway_method_response" "delete_post_403_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.delete.id
  http_method = aws_api_gateway_method.delete_post.http_method
  status_code = "403"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "delete_post_integration_403_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.delete.id
  http_method = aws_api_gateway_method.delete_post.http_method
  status_code = "403"
  depends_on = [
    aws_api_gateway_integration.delete_lambda,
    aws_api_gateway_method_response.delete_post_403_response
  ]
  selection_pattern = ".*statusCode\":403.*"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

resource "aws_api_gateway_method_response" "delete_post_404_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.delete.id
  http_method = aws_api_gateway_method.delete_post.http_method
  status_code = "404"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "delete_post_integration_404_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.delete.id
  http_method = aws_api_gateway_method.delete_post.http_method
  status_code = "404"
  depends_on = [
    aws_api_gateway_integration.delete_lambda,
    aws_api_gateway_method_response.delete_post_404_response
  ]
  selection_pattern = ".*statusCode\":404.*"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

resource "aws_api_gateway_method_response" "delete_post_500_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.delete.id
  http_method = aws_api_gateway_method.delete_post.http_method
  status_code = "500"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "delete_post_integration_500_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.delete.id
  http_method = aws_api_gateway_method.delete_post.http_method
  status_code = "500"
  depends_on = [
    aws_api_gateway_integration.delete_lambda,
    aws_api_gateway_method_response.delete_post_500_response
  ]
  selection_pattern = ".*statusCode\":500.*"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

# --- Total GET Method Responses ---
resource "aws_api_gateway_method_response" "total_get_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.total.id
  http_method = aws_api_gateway_method.total_get.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "total_get_integration_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.total.id
  http_method = aws_api_gateway_method.total_get.http_method
  status_code = "200"
  depends_on = [
    aws_api_gateway_integration.total_lambda,
    aws_api_gateway_method_response.total_get_200_response
  ]
  selection_pattern = ""
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

# --- Link POST Method Responses ---
resource "aws_api_gateway_method_response" "link_post_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.link.id
  http_method = aws_api_gateway_method.link_post.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "link_post_integration_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.link.id
  http_method = aws_api_gateway_method.link_post.http_method
  status_code = "200"

  depends_on = [
    aws_api_gateway_integration.link_lambda,
    aws_api_gateway_method_response.link_post_200_response
  ]

  selection_pattern = ""

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

# --- Exchange POST Method Responses ---
resource "aws_api_gateway_method_response" "exchange_post_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.exchange.id
  http_method = aws_api_gateway_method.exchange_post.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "exchange_post_integration_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.exchange.id
  http_method = aws_api_gateway_method.exchange_post.http_method
  status_code = "200"

  depends_on = [
    aws_api_gateway_integration.exchange_lambda,
    aws_api_gateway_method_response.exchange_post_200_response
  ]

  selection_pattern = ""

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

# --- Accounts GET Method Responses ---
resource "aws_api_gateway_method_response" "accounts_get_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.accounts.id
  http_method = aws_api_gateway_method.accounts_get.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "accounts_get_integration_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.accounts.id
  http_method = aws_api_gateway_method.accounts_get.http_method
  status_code = "200"

  depends_on = [
    aws_api_gateway_integration.accounts_lambda,
    aws_api_gateway_method_response.accounts_get_200_response
  ]

  selection_pattern = ""

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

# --- Transactions SYNC Method Responses ---
resource "aws_api_gateway_method_response" "transactions_sync_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.transactions_sync.id
  http_method = aws_api_gateway_method.transactions_sync_post.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "transactions_sync_post_integration_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.transactions_sync.id
  http_method = aws_api_gateway_method.transactions_sync_post.http_method
  status_code = "200"

  depends_on = [
    aws_api_gateway_integration.transactions_sync_lambda,
    aws_api_gateway_method_response.transactions_sync_200_response
  ]

  selection_pattern = ""

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

# --- Transactions LIST Method Responses ---
resource "aws_api_gateway_method_response" "transactions_list_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.transactions_list.id
  http_method = aws_api_gateway_method.transactions_list_post.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "transactions_list_post_integration_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.transactions_list.id
  http_method = aws_api_gateway_method.transactions_list_post.http_method
  status_code = "200"

  depends_on = [
    aws_api_gateway_integration.transactions_list_lambda,
    aws_api_gateway_method_response.transactions_list_200_response
  ]

  selection_pattern = ""

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

# --- Transactions GET Method Responses ---
resource "aws_api_gateway_method_response" "transactions_get_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.transactions_get.id
  http_method = aws_api_gateway_method.transactions_get_post.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "transactions_get_post_integration_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.transactions_get.id
  http_method = aws_api_gateway_method.transactions_get_post.http_method
  status_code = "200"

  depends_on = [
    aws_api_gateway_integration.transactions_get_lambda,
    aws_api_gateway_method_response.transactions_get_200_response
  ]

  selection_pattern = ""

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

# --- Transactions SYNC Method Responses ---
resource "aws_api_gateway_method_response" "transactions_status_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.transactions_status.id
  http_method = aws_api_gateway_method.transactions_status_post.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "transactions_status_post_integration_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.transactions_status.id
  http_method = aws_api_gateway_method.transactions_status_post.http_method
  status_code = "200"

  depends_on = [
    aws_api_gateway_integration.transactions_status_lambda,
    aws_api_gateway_method_response.transactions_status_200_response
  ]

  selection_pattern = ""

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

# --- Balance GET Method Responses ---
resource "aws_api_gateway_method_response" "balance_get_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.balance.id
  http_method = aws_api_gateway_method.balance_get.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "balance_get_integration_200_response" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id
  resource_id = aws_api_gateway_resource.balance.id
  http_method = aws_api_gateway_method.balance_get.http_method
  status_code = "200"

  depends_on = [
    aws_api_gateway_integration.balance_lambda,
    aws_api_gateway_method_response.balance_get_200_response
  ]

  selection_pattern = ""

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

##########################################
# ⚙️ API Gateway Gateway Responses (for CORS on internal errors/auth failures)
##########################################

resource "aws_api_gateway_gateway_response" "et_api_unauthorized_response" {
  rest_api_id     = aws_api_gateway_rest_api.et_api.id
  response_type   = "UNAUTHORIZED" # This specifically handles 401s from authorizer failures
  status_code     = "401" # Ensure the status code matches, although UNAUTHORIZED defaults to 401

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

resource "aws_api_gateway_gateway_response" "et_api_access_denied_response" {
  rest_api_id     = aws_api_gateway_rest_api.et_api.id
  response_type   = "ACCESS_DENIED" # This handles 403s (e.g., from IAM policies)
  # status_code = "403" # ACCESS_DENIED defaults to 403

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

###########################
# 🚀 Deployment & Staging
###########################

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.et_api.id

  depends_on = [
    aws_api_gateway_integration.add_lambda,
    aws_api_gateway_integration.get_lambda,
    aws_api_gateway_integration.export_lambda,
    aws_api_gateway_integration.meta_lambda,
    aws_api_gateway_integration.meta_post_lambda,
    aws_api_gateway_integration.edit_lambda,
    aws_api_gateway_integration.delete_lambda,
    aws_api_gateway_integration.total_lambda,
    aws_api_gateway_integration.link_lambda,
    aws_api_gateway_integration.exchange_lambda,
    aws_api_gateway_integration.accounts_lambda,
    aws_api_gateway_integration.transactions_sync_lambda,
    aws_api_gateway_integration.balance_lambda,

    # NEW: Transactions LIST
    aws_api_gateway_integration.transactions_list_lambda,
    aws_api_gateway_method_response.transactions_list_200_response,
    aws_api_gateway_integration_response.transactions_list_post_integration_200_response,

    # NEW: Transactions GET
    aws_api_gateway_integration.transactions_get_lambda,
    aws_api_gateway_method_response.transactions_get_200_response,
    aws_api_gateway_integration_response.transactions_get_post_integration_200_response,

    # NEW: Transactions STATUS
    aws_api_gateway_integration.transactions_status_lambda,
    aws_api_gateway_method_response.transactions_status_200_response,
    aws_api_gateway_integration_response.transactions_status_post_integration_200_response,

    # Existing responses...
    aws_api_gateway_method_response.add_post_200_response,
    aws_api_gateway_integration_response.add_post_integration_200_response,
    aws_api_gateway_method_response.get_get_200_response,
    aws_api_gateway_integration_response.get_get_integration_200_response,
    aws_api_gateway_method_response.export_get_200_response,
    aws_api_gateway_integration_response.export_get_integration_200_response,

    aws_api_gateway_method_response.meta_get_200_response,
    aws_api_gateway_method_response.meta_get_400_response,
    aws_api_gateway_integration_response.meta_get_integration_200_response,
    aws_api_gateway_integration_response.meta_get_integration_400_response,

    aws_api_gateway_method_response.meta_post_200_response,
    aws_api_gateway_integration_response.meta_post_integration_200_response,

    aws_api_gateway_method_response.edit_post_200_response,
    aws_api_gateway_integration_response.edit_post_integration_200_response,
    aws_api_gateway_method_response.edit_post_400_response,
    aws_api_gateway_integration_response.edit_post_integration_400_response,
    aws_api_gateway_method_response.edit_post_403_response,
    aws_api_gateway_integration_response.edit_post_integration_403_response,
    aws_api_gateway_method_response.edit_post_404_response,
    aws_api_gateway_integration_response.edit_post_integration_404_response,
    aws_api_gateway_method_response.edit_post_500_response,
    aws_api_gateway_integration_response.edit_post_integration_500_response,

    aws_api_gateway_method_response.delete_post_200_response,
    aws_api_gateway_integration_response.delete_post_integration_200_response,
    aws_api_gateway_method_response.delete_post_400_response,
    aws_api_gateway_integration_response.delete_post_integration_400_response,
    aws_api_gateway_method_response.delete_post_403_response,
    aws_api_gateway_integration_response.delete_post_integration_403_response,
    aws_api_gateway_method_response.delete_post_404_response,
    aws_api_gateway_integration_response.delete_post_integration_404_response,
    aws_api_gateway_method_response.delete_post_500_response,
    aws_api_gateway_integration_response.delete_post_integration_500_response,

    aws_api_gateway_method_response.total_get_200_response,
    aws_api_gateway_integration_response.total_get_integration_200_response,

    aws_api_gateway_method_response.link_post_200_response,
    aws_api_gateway_integration_response.link_post_integration_200_response,

    aws_api_gateway_method_response.exchange_post_200_response,
    aws_api_gateway_integration_response.exchange_post_integration_200_response,

    aws_api_gateway_method_response.accounts_get_200_response,
    aws_api_gateway_integration_response.accounts_get_integration_200_response,

    aws_api_gateway_method_response.transactions_sync_200_response,
    aws_api_gateway_integration_response.transactions_sync_post_integration_200_response,

    aws_api_gateway_method_response.balance_get_200_response,
    aws_api_gateway_integration_response.balance_get_integration_200_response,

    aws_api_gateway_gateway_response.et_api_unauthorized_response,
    aws_api_gateway_gateway_response.et_api_access_denied_response,
  ]

  triggers = {
    redeploy_timestamp = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.et_api.id
  stage_name    = "prod"
}
