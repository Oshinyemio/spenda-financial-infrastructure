#################################
# 🐍 Exchange Lambda Variables
#################################

variable "project_name" {
  type        = string
  description = "Project name for naming Lambda resources"
}

variable "lambda_role_arn" {
  type        = string
  description = "IAM role ARN for the Lambda function"
}

variable "lambda_zip_path" {
  type        = string
  description = "Path to the deployed Lambda .zip file"
}

variable "plaid_client_id" {
  type        = string
  description = "Plaid Client ID"
}

variable "plaid_secret" {
  type        = string
  description = "Plaid Secret"
}

variable "plaid_env" {
  type        = string
  description = "Plaid environment (sandbox, development, production)"
}

variable "plaid_items_table" {
  type        = string
  description = "Plaid items DynamoDB table name"
}

variable "layers" {
  type        = list(string)
  description = "Lambda layer ARNs"
  default     = []
}
