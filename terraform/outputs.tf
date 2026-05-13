#################################
# 🌐 Public App & API Endpoints
#################################

output "frontend_url" {
  description = "Public CloudFront URL for the frontend"
  value       = "https://${module.frontend.cloudfront_url}"
}

output "api_base_url" {
  description = "API Gateway base invoke URL"
  value       = module.api.api_invoke_url
}

#################################
# 🔐 Cognito (Auth Debug / Config)
#################################

output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = module.cognito.user_pool_id
}

output "cognito_user_pool_client_id" {
  description = "Cognito User Pool App Client ID"
  value       = module.cognito.user_pool_client_id
}

output "cognito_identity_pool_id" {
  description = "Cognito Identity Pool ID"
  value       = module.cognito.identity_pool_id
}

output "cognito_domain_url" {
  description = "Cognito Hosted UI base domain URL"
  value       = module.cognito.cognito_domain_url
}