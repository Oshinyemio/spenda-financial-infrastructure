# api/variables.tf

#################################
# 🔧 API Gateway Module Variables
#################################

# 🏷️ Project-wide name prefix (e.g., "myET")
variable "project_name" {
  type        = string
  default     = "et"
  description = "Name of the project (used for naming API resources)"
}

# 📍 Region and stage
variable "aws_region" {
  type        = string
  description = "AWS region (e.g., us-east-1)"
  default     = "us-east-1"
}

variable "stage_name" {
  type        = string
  description = "API Gateway stage name (e.g., prod, dev)"
  default     = "prod"
}

# 👤 AWS Account ID (passed from root)
variable "aws_account_id" {
  type        = string
  description = "The AWS account ID where resources are deployed. This should be passed from a data source in your root module."
}

# 🔐 Cognito for securing API
variable "cognito_user_pool_arn" {
  type        = string
  description = "ARN of the Cognito User Pool used for API authorization"
}

# ⚙️ Lambda: Add Expense
variable "add_lambda_function_name" {
  type        = string
  description = "Name of the Add Expense Lambda function"
}

variable "add_lambda_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Add Expense Lambda function"
}

# ⚙️ Lambda: Get Expense
variable "get_lambda_function_name" {
  type        = string
  description = "Name of the Get Expense Lambda function"
}

variable "get_lambda_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Get Expense Lambda function"
}

# ⚙️ Lambda: Export Expense
variable "export_lambda_function_name" {
  type        = string
  description = "Name of the Export Expense Lambda function"
}

variable "export_lambda_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Export Expense Lambda function"
}

# ⚙️ Lambda: Metadata
variable "meta_lambda_function_name" {
  type        = string
  description = "Name of the Metadata Lambda function"
}

variable "meta_lambda_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Metadata Lambda function"
}

# ⚙️ Lambda: Edit Expense
variable "edit_lambda_function_name" {
  type        = string
  description = "Name of the Edit Expense Lambda function"
}

variable "edit_lambda_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Edit Expense Lambda function"
}

# ⚙️ Lambda: Delete Expense (NEW)
variable "delete_lambda_function_name" {
  type        = string
  description = "Name of the Delete Expense Lambda function"
}

variable "delete_lambda_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Delete Expense Lambda function"
}

# ⚙️ Lambda: Total Expense (NEW)
variable "total_lambda_function_name" {
  type        = string
  description = "Name of the Total Expense Lambda function"
}

variable "total_lambda_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Total Expense Lambda function"
}

# ⚙️ Lambda: Link (Plaid Link Token Generator)
variable "link_lambda_function_name" {
  type        = string
  description = "Name of the Link (Plaid Link Token) Lambda function"
}

variable "link_lambda_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Link Lambda function"
}

# ⚙️ Lambda: Exchange (Plaid public_token → access_token)
variable "exchange_lambda_function_name" {
  type        = string
  description = "Name of the Exchange Lambda function"
}

variable "exchange_lambda_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Exchange Lambda function"
}

# ⚙️ Lambda: Accounts (Plaid /accounts → account list)
variable "accounts_lambda_function_name" {
  type        = string
  description = "Name of the Accounts Lambda function"
}

variable "accounts_lambda_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Accounts Lambda function"
}

# ⚙️ Lambda: Transactions (Plaid /transactions/sync → transaction list)
variable "transactions_lambda_function_name" {
  type        = string
  description = "Name of the Transactions Lambda function"
}

variable "transactions_lambda_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Transactions Lambda function"
}

# ⚙️ Lambda: Balance (Plaid /accounts/balance/get → balances)
variable "balance_lambda_function_name" {
  type        = string
  description = "Name of the Balance Lambda function"
}

variable "balance_lambda_invoke_arn" {
  type        = string
  description = "Invoke ARN of the Balance Lambda function"
}
