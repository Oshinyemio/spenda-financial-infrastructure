#################################
# 🌐 AWS Region & Stage Variables
#################################

variable "aws_region" {
  description = "AWS region (e.g. us-east-1)"
  type        = string
  default     = "us-east-1"   # ← or set your preferred region
}

variable "stage_name" {
  description = "API Gateway stage name (e.g. prod, dev)"
  type        = string
  default     = "prod"        # ← you can set a sensible default here
}

#####################################
# 🔐 Google OAuth Credentials
#####################################
variable "google_client_id" {
  description = "Google OAuth Client ID for Cognito IdP"
  type        = string
  sensitive   = true
}

variable "google_client_secret" {
  description = "Google OAuth Client Secret for Cognito IdP"
  type        = string
  sensitive   = true
}

###########################################
# 🏦 Plaid API Credentials & Environment
###########################################

variable "plaid_client_id" {
  description = "Plaid Client ID"
  type        = string
  sensitive   = true
}

variable "plaid_secret" {
  description = "Plaid Secret"
  type        = string
  sensitive   = true
}

variable "plaid_env" {
  description = "Plaid environment (sandbox, development, production)"
  type        = string
  default     = "sandbox"
}
