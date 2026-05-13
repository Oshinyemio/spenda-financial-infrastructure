#################################
# 📤 S3 Data Bucket Outputs
#################################

# 🪣 Name of the data S3 bucket
output "bucket_name" {
  value = aws_s3_bucket.data.id
}

# 📛 ARN of the data S3 bucket
output "bucket_arn" {
  value = aws_s3_bucket.data.arn
}
