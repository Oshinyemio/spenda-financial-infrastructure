#################################
# 🧩 Plaid Layer Variables
#################################

variable "project_name" {
  type        = string
  description = "Project name used for naming the Plaid Lambda Layer"
}

variable "layer_zip_path" {
  type        = string
  description = "Path to the zipped Plaid Lambda Layer file"
}
