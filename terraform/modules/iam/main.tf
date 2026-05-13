###############################
# 🛠️ IAM Role for Lambda Functions
###############################

resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Principal: {
          Service: "lambda.amazonaws.com"
        },
        Action: "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Project = var.project_name
  }
}

###############################
# 📜 IAM Policy for Lambda Permissions
###############################

resource "random_id" "lambda_policy_suffix" {
  byte_length = 4
}

resource "aws_iam_policy" "lambda_policy" {
  name = "${var.project_name}-lambda-policy-${random_id.lambda_policy_suffix.hex}"

  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Action: [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:Scan",
          "dynamodb:DeleteItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:DescribeTable",
          "dynamodb:ListTables"
        ],
        Resource: [
          var.dynamodb_table_arn,
          "${var.dynamodb_table_arn}/index/*",
          var.meta_table_arn,
          var.plaid_items_table_arn,
          var.plaid_transactions_table_arn,
          var.plaid_cursors_table_arn
        ]
      },
      {
        Effect: "Allow",
        Action: [
          "s3:PutObject",
          "s3:GetObject"
        ],
        Resource = "${var.s3_bucket_arn}/*"
      },
      {
        Effect: "Allow",
        Action: [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

###############################
# 🔗 Attach Lambda Policy to IAM Role
###############################

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
