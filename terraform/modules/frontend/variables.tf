##############################
# 🔧 Frontend Module Variables
##############################

# 🏷️ Project Name Prefix
variable "project_name" {
  description = "Name of the project (used for naming the frontend S3 bucket)"
  type        = string
  default     = "et"    # ← a sensible default
}

# 🌐 API Gateway Base URL
variable "api_base" {
  description = "Base URL for the API Gateway"
  type        = string
}

# 🔑 Cognito User Pool ID
variable "user_pool_id" {
  description = "Cognito User Pool ID"
  type        = string
}

# 🔐 Cognito App Client ID
variable "client_id" {
  description = "Cognito App Client ID"
  type        = string
}

# 🌐 Cognito Domain URL
variable "cognito_domain" {
  description = "Cognito Hosted UI domain URL"
  type        = string
}