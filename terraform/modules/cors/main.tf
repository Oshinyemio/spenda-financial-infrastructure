# cors/main.tf

# This module creates the necessary API Gateway resources for CORS preflight (OPTIONS method)
# and ensures the correct CORS headers are returned for the main method responses.

# ⚙️ OPTIONS method to enable CORS preflight requests
resource "aws_api_gateway_method" "options" {
  rest_api_id   = var.rest_api_id
  resource_id   = var.resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# 🔧 MOCK integration to respond to OPTIONS with 200 status for CORS
resource "aws_api_gateway_integration" "options" {
  rest_api_id          = var.rest_api_id
  resource_id          = var.resource_id
  http_method          = aws_api_gateway_method.options.http_method
  type                 = "MOCK" # Explicitly set to MOCK for preflight
  passthrough_behavior = "WHEN_NO_MATCH"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# 📝 Method response defining allowed headers, methods, and origins
resource "aws_api_gateway_method_response" "options" {
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# 📤 Integration response sending actual CORS headers
resource "aws_api_gateway_integration_response" "options" {
  depends_on  = [
    aws_api_gateway_integration.options,
    aws_api_gateway_method_response.options
  ]

  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.options.http_method
  status_code = aws_api_gateway_method_response.options.status_code

  response_templates = {
    "application/json" = "{}"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'${var.allowed_headers}'"
    "method.response.header.Access-Control-Allow-Methods" = "'${join(",", var.allowed_methods)}'"
    "method.response.header.Access-Control-Allow-Origin"  = "'${var.allowed_origins[0]}'"
  }
}