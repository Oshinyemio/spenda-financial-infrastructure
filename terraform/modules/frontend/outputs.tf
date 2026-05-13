##############################
# 🏷️ Frontend Module Outputs
##############################

# 📦 S3 Bucket Name for Frontend Hosting
output "frontend_bucket_name" {
  value = aws_s3_bucket.frontend.id
}

# 🌐 CloudFront Distribution Domain Name (URL)
output "cloudfront_url" {
  value = aws_cloudfront_distribution.frontend_cdn.domain_name
}

# 🏷️ ARN of the Frontend S3 Bucket
output "frontend_bucket_arn" {
  description = "ARN of the frontend S3 bucket"
  value       = aws_s3_bucket.frontend.arn
}
