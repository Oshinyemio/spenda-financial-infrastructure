##########################
# 🏷️ IAM Role Outputs
##########################

# 🧩 Lambda Execution Role ARN
output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}