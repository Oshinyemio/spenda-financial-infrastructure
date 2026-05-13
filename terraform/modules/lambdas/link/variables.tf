#################################
# 🐍 Plaid Link Lambda Variables
#################################

variable "project_name" {
  type        = string
  description = "Project name used for tagging and naming Lambda function"
}

variable "lambda_role_arn" {
  type        = string
  description = "IAM role ARN assigned to this Lambda function"
}

variable "lambda_zip_path" {
  type        = string
  description = "Path to the zipped Lambda deployment package"
}

# 🧩 Plaid API environment variables
variable "plaid_client_id" {
  type        = string
  description = "Plaid Client ID"
}

variable "plaid_secret" {
  type        = string
  description = "Plaid Secret Key"
}

variable "plaid_env" {
  type        = string
  description = "Plaid environment (sandbox, development, production)"
}

variable "layers" {
  type        = list(string)
  description = "List of Lambda layer ARNs to attach"
  default     = []
}
