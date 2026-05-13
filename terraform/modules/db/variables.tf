###############################
# 🗄️ DynamoDB Module Variables
###############################

# 🏷️ The name of the DynamoDB table
variable "table_name" {
  type        = string
  description = "The name of the DynamoDB table"
}

# 📛 Name of the project (used for tagging)
variable "project_name" {
  type        = string
  description = "Name of the project"
}

# 🏷️ The name of the DynamoDB metadata table
variable "meta_table_name" {
  type        = string
  description = "The name of the DynamoDB metadata table (users, categories)"
}

#################################
# 🗄️ DynamoDB Plaid Items Table Variables
#################################

# 🏷️ The name of the DynamoDB Plaid items table
variable "plaid_items_table_name" {
  type        = string
  description = "The name of the DynamoDB Plaid items table (stores Plaid item/access tokens per user)"
}
