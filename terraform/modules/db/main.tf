#################################
# 🗄️ DynamoDB Expense Table Setup
#################################

resource "aws_dynamodb_table" "expense_table" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"  # Use on-demand capacity mode for cost efficiency

  # 🗝️ Primary key: accountId (partition key) + expenseId (sort key)
  hash_key     = "accountId"
  range_key    = "expenseId"

  # 🏷️ Attribute definitions
  attribute {
    name = "accountId"
    type = "S"  # Cognito sub (string)
  }

  attribute {
    name = "expenseId"
    type = "S"  # Logical user profile
  }

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "category"
    type = "S"
  }

  global_secondary_index {
    name               = "user-category-index"
    hash_key           = "userId"
    range_key          = "category"
    projection_type    = "ALL"
  }

  tags = {
    Project = var.project_name
  }
}

#################################
# 🗄️ DynamoDB Metadata Table Setup
#################################

resource "aws_dynamodb_table" "meta_table" {
  name         = var.meta_table_name
  billing_mode = "PAY_PER_REQUEST" # Use on-demand capacity mode for cost efficiency

  # 🗝️ Primary key: accountId (partition key) + metaKey (sort key)
  hash_key     = "accountId"
  range_key    = "metaKey" 

  # 🏷️ Attribute definitions
  attribute {
    name = "accountId"
    type = "S" # Cognito sub (string)
  }

  attribute {
    name = "metaKey" # <--- NEW ATTRIBUTE DEFINITION FOR THE SORT KEY
    type = "S" # e.g., 'user#john', 'category#food'
  }

  tags = {
    Project = var.project_name
  }
}

#################################
# 🗄️ DynamoDB Plaid Items Table
#################################

resource "aws_dynamodb_table" "plaid_items_table" {
  name         = var.plaid_items_table_name
  billing_mode = "PAY_PER_REQUEST" # On-demand capacity

  # 🗝️ Primary key: accountId (PK) + item_id (SK)
  hash_key     = "accountId"
  range_key    = "item_id"

  # 🏷️ Attribute definitions
  attribute {
    name = "accountId"
    type = "S"   # Cognito sub (string)
  }

  attribute {
    name = "item_id"
    type = "S"   # Plaid item_id
  }

  tags = {
    Project = var.project_name
  }
}

#################################
# 🗄️ DynamoDB Plaid Transactions Table
#################################

resource "aws_dynamodb_table" "plaid_transactions_table" {
  name         = "${var.project_name}-plaid-transactions"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "accountId"
  range_key = "transaction_id"

  attribute {
    name = "accountId"
    type = "S"
  }

  attribute {
    name = "transaction_id"
    type = "S"
  }

  tags = {
    Project = var.project_name
  }
}

#################################
# 🗄️ DynamoDB Plaid Items Table
#################################

resource "aws_dynamodb_table" "plaid_cursors_table" {
  name         = "${var.project_name}-plaid-cursors"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "accountId"
  range_key = "item_id"

  attribute {
    name = "accountId"
    type = "S"
  }

  attribute {
    name = "item_id"
    type = "S"
  }

  tags = {
    Project = var.project_name
  }
}
