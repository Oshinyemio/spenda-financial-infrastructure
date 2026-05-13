#################################
# 📦 S3 Data Bucket Resources
#################################

# 🔑 Random suffix to ensure unique bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# 🪣 S3 bucket for storing expense tracker data
resource "aws_s3_bucket" "data" {
  bucket = "et-data-${random_id.bucket_suffix.hex}"

  tags = {
    Project = var.project_name
  }
}

# 🛡️ Ownership controls to enforce bucket owner preference
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.data.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# 🚫 Block all public access to the bucket for security
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.data.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}
