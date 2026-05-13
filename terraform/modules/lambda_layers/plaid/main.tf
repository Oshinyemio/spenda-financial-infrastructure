#################################
# 🧩 Plaid Python SDK Lambda Layer
#################################

resource "aws_lambda_layer_version" "plaid_layer" {
  layer_name          = "${var.project_name}-plaid-layer"
  filename            = var.layer_zip_path
  compatible_runtimes = ["python3.12"]

  description = "Plaid Python SDK layer for ${var.project_name}"

  source_code_hash = filebase64sha256(var.layer_zip_path)
}
