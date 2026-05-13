########################
# 🔐 Cognito User Pool
########################
resource "aws_cognito_user_pool" "this" {
  name = "${var.project_name}-user-pool"

  # Users log in with email
  username_attributes      = ["email"]

  # ✅ Only verify emails automatically
  auto_verified_attributes = ["email"]

  user_attribute_update_settings {
    attributes_require_verification_before_update = ["email"]
  }

  schema {
    name                = "preferred_username"
    attribute_data_type = "String"
    required            = true
    mutable             = true
  }

  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
    mutable             = true
  }

  # Optional phone number field (not used for MFA)
  schema {
    name                = "phone_number"
    attribute_data_type = "String"
    required            = false
    mutable             = true
  }

  # ✅ Custom attribute for staging email changes
  schema {
    name                = "pending_email"
    attribute_data_type = "String"
    required            = false
    mutable             = true
    
    string_attribute_constraints {
      min_length = 0
      max_length = 256
    }
  }

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = true
  }

  ########################
  # 🔐 MFA Configuration
  ########################
  # Let users choose: no MFA, Authenticator, or Email (email toggled manually)
  mfa_configuration = "OPTIONAL"

  # Enable Authenticator App MFA
  software_token_mfa_configuration {
    enabled = true
  }

  # 🧹 SMS is completely removed (no SNS setup)
  # sms_configuration {}
  # sms_verification_message = "Your Spenda verification code is {####}"

  # ✅ Email verification template for signup/forgot-password
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  # ✅ Prevent Terraform from unnecessary schema re-deploys
  lifecycle {
     ignore_changes = [schema]
  }
}

########################
# 🧩 User Pool Client
########################
resource "aws_cognito_user_pool_client" "this" {
  name         = "${var.user_pool_name}-client"
  user_pool_id = aws_cognito_user_pool.this.id

  # For public SPA clients, no secret
  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

  prevent_user_existence_errors = "ENABLED"

  callback_urls = var.callback_urls
  logout_urls   = var.logout_urls

  supported_identity_providers         = ["COGNITO", "Google"]

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]

  access_token_validity  = 30  # minutes
  id_token_validity      = 30  # minutes
  refresh_token_validity = 1   # days

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }

  depends_on = [
    aws_cognito_user_pool.this,
    # ensures Google IdP exists before referencing it
    aws_cognito_identity_provider.google
  ]
}

########################
# 🌐 User Pool Domain
########################
resource "random_id" "domain_suffix" {
  byte_length = 4
}

resource "aws_cognito_user_pool_domain" "this" {
  domain       = "${var.domain_prefix}-${random_id.domain_suffix.hex}"
  user_pool_id = aws_cognito_user_pool.this.id
}

########################
# 🆔 Cognito Identity Pool
########################
resource "aws_cognito_identity_pool" "this" {
  identity_pool_name               = "${var.user_pool_name}-identity-pool"
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.this.id
    provider_name           = aws_cognito_user_pool.this.endpoint
    server_side_token_check = false
  }
}

########################
# 🔐 IAM Role for Cognito Authenticated Users
########################
resource "aws_iam_role" "cognito_authenticated" {
  name = "${var.project_name}_cognito_authenticated_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "cognito-identity.amazonaws.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "cognito-identity.amazonaws.com:aud" = aws_cognito_identity_pool.this.id
          }
          "ForAnyValue:StringLike" = {
            "cognito-identity.amazonaws.com:amr" = "authenticated"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "cognito_api_access" {
  name = "${var.project_name}_cognito_api_access"
  role = aws_iam_role.cognito_authenticated.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["execute-api:Invoke"]
        Resource = "*"
      }
    ]
  })
}

########################
# 🎭 Identity Pool Roles Attachment
########################
resource "aws_cognito_identity_pool_roles_attachment" "this" {
  identity_pool_id = aws_cognito_identity_pool.this.id

  roles = {
    authenticated = aws_iam_role.cognito_authenticated.arn
  }
}

########################
# 🌐 Google Identity Provider
########################
resource "aws_cognito_identity_provider" "google" {
  user_pool_id  = aws_cognito_user_pool.this.id
  provider_name = "Google"
  provider_type = "Google"

  # 🔐 Securely reference credentials from SSM Parameter Store or Secrets Manager
  provider_details = {
    client_id       = aws_ssm_parameter.google_client_id.value
    client_secret   = aws_ssm_parameter.google_client_secret.value
    authorize_scopes = "openid email profile"
  }

  attribute_mapping = {
    email              = "email"
    given_name         = "given_name"
    family_name        = "family_name"
    name               = "name"
    preferred_username = "sub"
    picture            = "picture"
  }
}