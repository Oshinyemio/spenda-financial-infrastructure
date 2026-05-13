#################################
# 🔧 Cognito Auth Module Variables
#################################

# 🌍 AWS Region
variable "aws_region" {
  type        = string
  description = "AWS region (e.g., us-east-1)"
}

# 🏷️ Cognito User Pool Name
variable "user_pool_name" {
  type        = string
  description = "The name of the Cognito User Pool"
}

# 🔗 List of Allowed Callback URLs after Login
variable "callback_urls" {
  type        = list(string)
  description = "List of allowed callback URLs for OAuth2 login flows"
}

# 🔗 List of Allowed Logout URLs
variable "logout_urls" {
  type        = list(string)
  description = "List of allowed logout URLs for OAuth2 flows"
}

# 🌐 Domain Prefix for Cognito Hosted UI
variable "domain_prefix" {
  type        = string
  description = "Prefix for the Cognito Hosted UI domain (e.g., 'et-app' results in 'et-app.auth.us-east-1.amazoncognito.com')"
}

# 📛 Project Name (for resource naming)
variable "project_name" {
  type        = string
  description = "Project name prefix used for resource naming"
  default     = "et"
}

variable "authenticated_role_arn" {
  description = "IAM role ARN for authenticated users"
  type        = string
  default     = null
}

variable "google_client_id" {
  description = "Google OAuth Client ID"
  type        = string
  sensitive   = true
}

variable "google_client_secret" {
  description = "Google OAuth Client Secret"
  type        = string
  sensitive   = true
}
