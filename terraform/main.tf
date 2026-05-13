#################################
# 🌐 AWS Provider Configuration
#################################

provider "aws" {
  region = var.aws_region
}

# --- Data Source for current AWS account ID ---
# This fetches the account ID of the AWS identity running Terraform
data "aws_caller_identity" "current" {}

#################################
# 📦 DynamoDB Module
#################################

module "dynamodb" {
  source          = "./modules/db"
  table_name      = "et-expenses"
  meta_table_name = "et-metadata"
  plaid_items_table_name = "et-plaid_items"
  project_name    = "et"
}

#################################
# 🔐 IAM Module
#################################

module "iam" {
  source              = "./modules/iam"
  project_name        = "et"

  dynamodb_table_arn        = module.dynamodb.table_arn
  meta_table_arn            = module.dynamodb.meta_table_arn
  plaid_items_table_arn     = module.dynamodb.plaid_items_table_arn
  plaid_transactions_table_arn = module.dynamodb.plaid_transactions_table_arn
  plaid_cursors_table_arn      = module.dynamodb.plaid_cursors_table_arn

  s3_bucket_arn             = module.storage.bucket_arn
  identity_pool_id          = module.cognito.identity_pool_id
}

#################################
# 🗄️ S3 Data Bucket Module
#################################

module "storage" {
  source       = "./modules/storage"
  project_name = "et"
}

#################################
# 🐍 Lambda Modules
#################################

module "lambda_add" {
  source           = "./modules/lambdas/add"
  project_name     = "et"
  lambda_role_arn  = module.iam.lambda_role_arn
  lambda_zip_path  = "${path.root}/build/lambda_zips/add.zip"
  dynamodb_table   = module.dynamodb.table_name
  meta_table_name  = module.dynamodb.meta_table_name
  s3_bucket_name   = module.storage.bucket_name
}

module "lambda_get" {
  source           = "./modules/lambdas/get"
  project_name     = "et"
  lambda_role_arn  = module.iam.lambda_role_arn
  lambda_zip_path  = "${path.root}/build/lambda_zips/get.zip"
  dynamodb_table   = module.dynamodb.table_name
}

module "lambda_export" {
  source           = "./modules/lambdas/export"
  project_name     = "et"
  lambda_role_arn  = module.iam.lambda_role_arn
  lambda_zip_path  = "${path.root}/build/lambda_zips/export.zip"
  dynamodb_table   = module.dynamodb.table_name
  s3_bucket_name   = module.storage.bucket_name
}

module "lambda_meta" {
  source           = "./modules/lambdas/meta"
  project_name     = "et"
  lambda_role_arn  = module.iam.lambda_role_arn
  lambda_zip_path  = "${path.root}/build/lambda_zips/meta.zip"
  meta_table_name       = module.dynamodb.meta_table_name
}

module "lambda_edit" {
  source           = "./modules/lambdas/edit"
  project_name     = "et"
  lambda_role_arn  = module.iam.lambda_role_arn
  lambda_zip_path  = "${path.root}/build/lambda_zips/edit.zip"
  meta_table_name  = module.dynamodb.meta_table_name
  dynamodb_table   = module.dynamodb.table_name
  s3_bucket_name   = module.storage.bucket_name
}

module "lambda_delete" {
  source           = "./modules/lambdas/delete"
  project_name     = "et"
  lambda_role_arn  = module.iam.lambda_role_arn
  lambda_zip_path  = "${path.root}/build/lambda_zips/delete.zip"
  meta_table_name  = module.dynamodb.meta_table_name
  dynamodb_table   = module.dynamodb.table_name
  s3_bucket_name   = module.storage.bucket_name
}

module "lambda_total" {
  source           = "./modules/lambdas/total"
  project_name     = "et"
  lambda_role_arn  = module.iam.lambda_role_arn
  lambda_zip_path  = "${path.root}/build/lambda_zips/total.zip"
  dynamodb_table   = module.dynamodb.table_name
  meta_table_name  = module.dynamodb.meta_table_name
}

module "plaid_layer" {
  source        = "./modules/lambda_layers/plaid"
  project_name  = "et"
  layer_zip_path = "${path.root}/build/lambda_layers/plaid/plaid_layer.zip"
}

module "lambda_link" {
  source           = "./modules/lambdas/link"
  project_name     = "et"
  lambda_role_arn  = module.iam.lambda_role_arn
  lambda_zip_path  = "${path.root}/build/lambda_zips/link.zip"

  plaid_client_id    = var.plaid_client_id
  plaid_secret       = var.plaid_secret
  plaid_env          = var.plaid_env

  layers = [ module.plaid_layer.plaid_layer_arn ]

  depends_on = [ module.plaid_layer ]
}

module "lambda_exchange" {
  source            = "./modules/lambdas/exchange"
  project_name      = "et"
  lambda_role_arn   = module.iam.lambda_role_arn
  lambda_zip_path   = "${path.root}/build/lambda_zips/exchange.zip"

  plaid_client_id   = var.plaid_client_id
  plaid_secret      = var.plaid_secret
  plaid_env         = var.plaid_env
  plaid_items_table = module.dynamodb.plaid_items_table_name

  layers            = [ module.plaid_layer.plaid_layer_arn ]
  depends_on        = [ module.plaid_layer ]
}

module "lambda_accounts" {
  source            = "./modules/lambdas/accounts"
  project_name      = "et"
  lambda_role_arn   = module.iam.lambda_role_arn
  lambda_zip_path   = "${path.root}/build/lambda_zips/accounts.zip"

  plaid_client_id   = var.plaid_client_id
  plaid_secret      = var.plaid_secret
  plaid_env         = var.plaid_env
  plaid_items_table = module.dynamodb.plaid_items_table_name
}

module "lambda_transactions" {
  source            = "./modules/lambdas/transactions"
  project_name      = "et"
  lambda_role_arn   = module.iam.lambda_role_arn
  lambda_zip_path   = "${path.root}/build/lambda_zips/transactions.zip"

  plaid_client_id           = var.plaid_client_id
  plaid_secret              = var.plaid_secret
  plaid_env                 = var.plaid_env
  plaid_items_table         = module.dynamodb.plaid_items_table_name
  plaid_transactions_table  = module.dynamodb.plaid_transactions_table_name
  plaid_cursors_table       = module.dynamodb.plaid_cursors_table_name

  layers = [ module.plaid_layer.plaid_layer_arn ]
  depends_on = [ module.plaid_layer ]
}

module "lambda_balance" {
  source            = "./modules/lambdas/balance"
  project_name      = "et"
  lambda_role_arn   = module.iam.lambda_role_arn
  lambda_zip_path   = "${path.root}/build/lambda_zips/balance.zip"

  plaid_client_id   = var.plaid_client_id
  plaid_secret      = var.plaid_secret
  plaid_env         = var.plaid_env
  plaid_items_table = module.dynamodb.plaid_items_table_name

  layers = [ module.plaid_layer.plaid_layer_arn ]
  depends_on = [ module.plaid_layer ]
}

#################################
# 🚪 API Gateway Module
#################################

module "api" {
  source = "./modules/api"

  project_name = "et"
  aws_region   = var.aws_region
  stage_name   = var.stage_name
  aws_account_id = data.aws_caller_identity.current.account_id

  # Using standard ARNs for existing functions
  add_lambda_function_name    = module.lambda_add.add_lambda_name
  add_lambda_invoke_arn       = module.lambda_add.add_lambda_arn

  get_lambda_function_name    = module.lambda_get.get_lambda_name
  get_lambda_invoke_arn       = module.lambda_get.get_lambda_arn 

  export_lambda_function_name = module.lambda_export.export_lambda_name
  export_lambda_invoke_arn    = module.lambda_export.export_lambda_arn

  meta_lambda_function_name = module.lambda_meta.meta_lambda_name
  meta_lambda_invoke_arn    = module.lambda_meta.meta_lambda_arn

  edit_lambda_function_name = module.lambda_edit.edit_lambda_name
  edit_lambda_invoke_arn    = module.lambda_edit.edit_lambda_arn

  delete_lambda_function_name = module.lambda_delete.delete_lambda_name
  delete_lambda_invoke_arn    = module.lambda_delete.delete_lambda_arn

  total_lambda_function_name = module.lambda_total.total_lambda_name
  total_lambda_invoke_arn    = module.lambda_total.total_lambda_arn

  link_lambda_function_name     = module.lambda_link.link_lambda_name
  link_lambda_invoke_arn        = module.lambda_link.link_lambda_invoke_arn

  exchange_lambda_function_name = module.lambda_exchange.exchange_lambda_name
  exchange_lambda_invoke_arn    = module.lambda_exchange.exchange_lambda_invoke_arn

  accounts_lambda_function_name = module.lambda_accounts.accounts_lambda_name
  accounts_lambda_invoke_arn    = module.lambda_accounts.accounts_lambda_invoke_arn

  transactions_lambda_function_name = module.lambda_transactions.transactions_lambda_name
  transactions_lambda_invoke_arn    = module.lambda_transactions.transactions_lambda_invoke_arn

  balance_lambda_function_name = module.lambda_balance.balance_lambda_name
  balance_lambda_invoke_arn    = module.lambda_balance.balance_lambda_invoke_arn
 
  cognito_user_pool_arn = module.cognito.user_pool_arn

  # Explicitly depend on the Lambda modules to ensure they are fully deployed
  # before the API Gateway module attempts to create integrations.
  depends_on = [
    module.lambda_add,
    module.lambda_get,
    module.lambda_export,
    module.lambda_meta,
    module.lambda_edit,
    module.lambda_delete,
    module.lambda_total,
    module.lambda_link,
    module.lambda_exchange,
    module.lambda_accounts,
    module.lambda_transactions,
    module.lambda_balance
  ]
}

###########################
# 🌐 CORS Support Modules
###########################

module "cors_add" {
  source          = "./modules/cors" 
  rest_api_id     = module.api.rest_api_id
  resource_id     = module.api.add_resource_id
  allowed_methods = ["OPTIONS", "POST"]
  allowed_origins = ["https://${module.frontend.cloudfront_url}"]
}

module "cors_get" {
  source          = "./modules/cors"
  rest_api_id     = module.api.rest_api_id
  resource_id     = module.api.get_resource_id
  allowed_methods = ["OPTIONS", "GET"]
  allowed_origins = ["https://${module.frontend.cloudfront_url}"]
}

module "cors_export" {
  source          = "./modules/cors"
  rest_api_id     = module.api.rest_api_id
  resource_id     = module.api.export_resource_id
  allowed_methods = ["OPTIONS", "GET"]
  allowed_origins = ["https://${module.frontend.cloudfront_url}"]
}

module "cors_meta" {
  source          = "./modules/cors"
  rest_api_id     = module.api.rest_api_id
  resource_id     = module.api.meta_resource_id
  allowed_methods = ["OPTIONS", "GET", "POST"]
  allowed_origins = ["https://${module.frontend.cloudfront_url}"]
}

module "cors_edit" {
  source          = "./modules/cors"
  rest_api_id     = module.api.rest_api_id
  resource_id     = module.api.edit_resource_id
  allowed_methods = ["OPTIONS", "POST"]
  allowed_origins = ["https://${module.frontend.cloudfront_url}"]
}

module "cors_delete" {
  source          = "./modules/cors"
  rest_api_id     = module.api.rest_api_id
  resource_id     = module.api.delete_resource_id
  allowed_methods = ["OPTIONS", "POST"]
  allowed_origins = ["https://${module.frontend.cloudfront_url}"]
}

module "cors_total" {
  source          = "./modules/cors"
  rest_api_id     = module.api.rest_api_id
  resource_id     = module.api.total_resource_id
  allowed_methods = ["OPTIONS", "GET"]
  allowed_origins = ["https://${module.frontend.cloudfront_url}"]
}

module "cors_link" {
  source          = "./modules/cors"
  rest_api_id     = module.api.rest_api_id
  resource_id     = module.api.link_resource_id
  allowed_methods = ["OPTIONS", "POST"]
  allowed_origins = ["https://${module.frontend.cloudfront_url}"]
}

module "cors_exchange" {
  source          = "./modules/cors"
  rest_api_id     = module.api.rest_api_id
  resource_id     = module.api.exchange_resource_id
  allowed_methods = ["OPTIONS", "POST"]
  allowed_origins = ["https://${module.frontend.cloudfront_url}"]
}

module "cors_accounts" {
  source          = "./modules/cors"
  rest_api_id     = module.api.rest_api_id
  resource_id     = module.api.accounts_resource_id
  allowed_methods = ["OPTIONS", "GET"]
  allowed_origins = ["https://${module.frontend.cloudfront_url}"]
}

module "cors_transactions_sync" {
  source          = "./modules/cors"
  rest_api_id     = module.api.rest_api_id
  resource_id     = module.api.transactions_sync_resource_id
  allowed_methods = ["OPTIONS", "POST"]
  allowed_origins = ["https://${module.frontend.cloudfront_url}"]
}

module "cors_transactions_list" {
  source          = "./modules/cors"
  rest_api_id     = module.api.rest_api_id
  resource_id     = module.api.transactions_list_resource_id
  allowed_methods = ["OPTIONS", "POST"]
  allowed_origins = ["https://${module.frontend.cloudfront_url}"]
}

module "cors_transactions_get" {
  source          = "./modules/cors"
  rest_api_id     = module.api.rest_api_id
  resource_id     = module.api.transactions_get_resource_id
  allowed_methods = ["OPTIONS", "POST"]
  allowed_origins = ["https://${module.frontend.cloudfront_url}"]
}

module "cors_transactions_status" {
  source          = "./modules/cors"
  rest_api_id     = module.api.rest_api_id
  resource_id     = module.api.transactions_status_resource_id
  allowed_methods = ["OPTIONS", "POST"]
  allowed_origins = ["https://${module.frontend.cloudfront_url}"]
}

module "cors_balance" {
  source          = "./modules/cors"
  rest_api_id     = module.api.rest_api_id
  resource_id     = module.api.balance_resource_id
  allowed_methods = ["OPTIONS", "GET"]
  allowed_origins = ["https://${module.frontend.cloudfront_url}"]
}

#################################
# 🧑‍💻 Cognito Auth Module
#################################

module "cognito" {
  source         = "./modules/auth"
  user_pool_name = "et-user-pool"
  aws_region     = var.aws_region
  domain_prefix  = "et-auth"

  # 🚀 Use CloudFront URLs in production
  callback_urls = [
    format("https://%s/login.html", module.frontend.cloudfront_url)
  ]
  logout_urls = [
    format("https://%s/logout.html", module.frontend.cloudfront_url)
  ]

  google_client_id     = var.google_client_id
  google_client_secret = var.google_client_secret
}

#################################
# 🏠 Frontend Hosting Module
#################################

module "frontend" {
  source       = "./modules/frontend"

  api_base       = module.api.api_invoke_url
  user_pool_id   = module.cognito.user_pool_id
  client_id      = module.cognito.user_pool_client_id
  cognito_domain = module.cognito.cognito_domain_url
}