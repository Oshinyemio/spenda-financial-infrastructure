#################################
# 🧩 Transactions Lambda Variables
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
}

variable "plaid_secret" {
  type        = string
}

variable "plaid_env" {
  type        = string
}

variable "plaid_items_table" {
  type        = string
  description = "Name of the Plaid items DynamoDB table"
}

variable "plaid_transactions_table" {
  type        = string
  description = "Name of the Plaid transactions DynamoDB table"
}

variable "plaid_cursors_table" {
  type        = string
  description = "Name of the Plaid sync cursor DynamoDB table"
}

variable "layers" {
  type        = list(string)
  description = "Lambda layer ARNs"
  default     = []
}
