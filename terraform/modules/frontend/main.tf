#########################
# 🎨 Frontend Module
#########################

##############################
# 🔧 Config.js Template Setup
##############################
data "template_file" "config_js" {
  template = file("${path.module}/site/config.js.tpl")
  vars = {
    api_base     = var.api_base
    user_pool_id = var.user_pool_id
    client_id    = var.client_id
    cognito_domain = var.cognito_domain
  }
}

resource "local_file" "generated_config" {
  content  = data.template_file.config_js.rendered
  filename = "${path.module}/site/dist/config.js"
}

##########################
# ☁️ S3 Bucket for Frontend
##########################
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "frontend" {
  bucket = lower("${var.project_name}-frontend-${random_id.bucket_suffix.hex}")

  tags = {
    Name = "Frontend Hosting Bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

###########################
# 📄 Upload Static Web Files
###########################
locals {
  frontend_files = fileset("${path.module}/site/dist", "**/*")

  content_types = {
    ".html"  = "text/html"
    ".js"    = "application/javascript"
    ".css"   = "text/css"
    ".ico"   = "image/x-icon"
    ".png"   = "image/png"
    ".jpg"   = "image/jpeg"
    ".jpeg"  = "image/jpeg"
    ".svg"   = "image/svg+xml"
    ".woff"  = "font/woff"
    ".woff2" = "font/woff2"
  }
}

resource "aws_s3_object" "frontend_files" {
  for_each = { for f in local.frontend_files : f => f }

  bucket = aws_s3_bucket.frontend.id
  key    = each.key
  source = "${path.module}/site/dist/${each.value}"

  content_type = lookup(
    local.content_types,
    lower(regex("\\.[^.]+$", each.value)),
    "binary/octet-stream"
  )

  source_hash = filebase64sha256("${path.module}/site/dist/${each.value}")
}

######################################
# ☁️ CloudFront Origin Access Control
######################################
resource "aws_cloudfront_origin_access_control" "frontend_oac" {
  name                              = "${var.project_name}-frontend-oac-${random_id.bucket_suffix.hex}"
  description                       = "OAC for ${var.project_name} frontend CloudFront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "frontend_cdn" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.frontend.bucket_regional_domain_name
    origin_id   = "frontendS3"

    origin_access_control_id = aws_cloudfront_origin_access_control.frontend_oac.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "frontendS3"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "Frontend Distribution"
  }
}

##############################
# 🛡️ S3 Bucket Policy for CloudFront Access
##############################
resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowCloudFrontAccess",
        Effect    = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.frontend.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.frontend_cdn.arn
          }
        }
      }
    ]
  })
}

#################################
# 🚀 Optional: Force redeploy when site changes
#################################

resource "null_resource" "frontend_deploy_trigger" {
  # 👇 This ensures Terraform re-uploads when the build or config changes
  triggers = {
    config_hash = filemd5("${path.module}/site/dist/config.js")
    build_hash  = sha1(join("", [for f in local.frontend_files : filemd5("${path.module}/site/dist/${f}")]))
  }

  depends_on = [
    local_file.generated_config,
    aws_s3_object.frontend_files
  ]
}