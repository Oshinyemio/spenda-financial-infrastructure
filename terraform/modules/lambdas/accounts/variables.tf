#################################
# 🐍 Plaid Accounts Lambda Variables
#################################

# 🏷️ Project-wide name prefix (used for resource naming)
variable "project_name" {
  type        = string
  description = "Project name prefix"
}

# 🔐 ARN of the IAM role assumed by the Lambda function
variable "lambda_role_arn" {
  type        = string
  description = "IAM Role ARN for Lambda execution"
}

# 📦 Local path to the zipped Lambda deployment package
variable "lambda_zip_path" {
  type        = string
  description = "File path to Lambda deployment zip"
}

# 🗃️ Name of the DynamoDB table that stores Plaid link data
variable "plaid_items_table" {
  type        = string
  description = "DynamoDB Plaid items table name"
}

# 🔑 Plaid client ID
variable "plaid_client_id" {
  type        = string
  description = "Plaid client ID"
}

# 🔐 Plaid secret
variable "plaid_secret" {
  type        = string
  description = "Plaid secret"
  sensitive   = true
}

# 🌍 Plaid environment
variable "plaid_env" {
  type        = string
  description = "Plaid environment (sandbox, development, production)"
  default     = "sandbox"
}
