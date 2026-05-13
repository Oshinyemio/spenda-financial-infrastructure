#################################
# 📤 Export Expense Lambda Variables
#################################

# 🏷️ Project-wide name prefix (used for naming resources)
variable "project_name" {
  type        = string
  description = "Project name prefix for resource naming"
}

# 🔐 IAM Role ARN that the Export Expense Lambda function will assume
variable "lambda_role_arn" {
  type        = string
  description = "IAM Role ARN for Lambda execution permissions"
}

# 📦 Path to the zipped deployment package for the Export Expense Lambda function
variable "lambda_zip_path" {
  type        = string
  description = "Local file path to Export Expense Lambda zip package"
}

# 🗃️ DynamoDB table name where expense data is stored
variable "dynamodb_table" {
  type        = string
  description = "DynamoDB table name for storing expenses"
}

# 📦 S3 bucket name where exported CSV files will be saved
variable "s3_bucket_name" {
  type        = string
  description = "S3 bucket name for storing exported expense CSV files"
}
