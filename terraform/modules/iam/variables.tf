#################################
# 🔧 IAM Module Variables
#################################

# 🏷️ Project name prefix (used for naming roles and policies)
variable "project_name" {
  type = string
}

# 📋 ARN of the DynamoDB table (for Lambda permissions)
variable "dynamodb_table_arn" {
  type = string
}

# 📋 Metadata DynamoDB table ARN
variable "meta_table_arn" {
  type        = string
  description = "ARN of the DynamoDB metadata table (for users/categories)"
}

# 📋 Plaid items DynamoDB table ARN
variable "plaid_items_table_arn" {
  type        = string
  description = "ARN of the Plaid items DynamoDB table"
}

# 📋 Plaid transactions DynamoDB table ARN
variable "plaid_transactions_table_arn" {
  type        = string
  description = "ARN of the DynamoDB table storing synced Plaid transactions"
}

# 📋 Plaid cursors DynamoDB table ARN
variable "plaid_cursors_table_arn" {
  type        = string
  description = "ARN of the DynamoDB table storing Plaid sync cursors"
}

# 📦 ARN of the S3 bucket (for Lambda permissions)
variable "s3_bucket_arn" {
  type = string
}

# 🔐 Cognito Identity Pool ID (used in IAM role trust policy)
variable "identity_pool_id" {
  description = "Cognito Identity Pool ID (for role trust)"
  type        = string
}