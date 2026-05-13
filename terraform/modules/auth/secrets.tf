resource "aws_ssm_parameter" "google_client_id" {
  name  = "/spenda/google/client_id"
  type  = "String"
  value = var.google_client_id
}

resource "aws_ssm_parameter" "google_client_secret" {
  name  = "/spenda/google/client_secret"
  type  = "SecureString"
  value = var.google_client_secret
}