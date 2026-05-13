# cors/variables.tf

#################################
# 🔧 API Gateway CORS Module Variables
#################################

# 🆔 API Gateway REST API ID
variable "rest_api_id" {
  type        = string
  description = "ID of the API Gateway REST API"
}

# 🧱 API Gateway Resource ID
variable "resource_id" {
  type        = string
  description = "ID of the API Gateway resource to attach CORS settings"
}

# 📋 Allowed HTTP Methods for CORS
variable "allowed_methods" {
  type        = list(string)
  description = "List of HTTP methods allowed for CORS (e.g., [\"OPTIONS\", \"GET\", \"POST\"])"
  default     = ["POST"] # Default to POST, but will be overridden by module calls
}

# 🌐 Allowed Origins for CORS
variable "allowed_origins" {
  description = "List of origins allowed to access the resource (e.g., CloudFront URL)"
  type        = list(string)
  default     = [] # leave empty
}

# 📝 Allowed Headers for CORS
variable "allowed_headers" {
  description = "List of headers allowed in CORS requests."
  type        = string
  default     = "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token"
}
