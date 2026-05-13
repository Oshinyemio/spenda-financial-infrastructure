##################################
# 🔧 Get Expense Lambda Variables
##################################

# 🏷️ Project name prefix (used for naming the Lambda)
variable "project_name" {
  type = string
}

# 🔐 IAM Role ARN assigned to the Lambda function
variable "lambda_role_arn" {
  type = string
}

# 📦 Path to the zipped Lambda deployment package
variable "lambda_zip_path" {
  type = string
}

# 🗄️ DynamoDB table name used by the Lambda
variable "dynamodb_table" {
  type = string
}
