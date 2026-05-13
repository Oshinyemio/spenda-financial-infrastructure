// Global configuration injected at deploy time by Terraform

window.config = {
  apiBase: "${api_base}",
  userPoolId: "${user_pool_id}",
  clientId: "${client_id}",
  cognitoDomain: "${cognito_domain}"
};