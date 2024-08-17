#Create a CloudFront distribution with the S3 bucket as the origin. Configure default cache behavior and viewer protocol policy.

# Fetching S3 Bucket Data
data "aws_s3_bucket" "s3_bucket" {
  bucket = "empirestorybook"
}

# Creating CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "storybook" {
  name                        = "S3-${data.aws_s3_bucket.s3_bucket.id}"
  origin_access_control_origin_type = "s3"
  signing_behavior            = "always"
  signing_protocol            = "sigv4"
}

# Creating CloudFront Distribution
resource "aws_cloudfront_distribution" "example_distribution" {
  origin {
    domain_name = data.aws_s3_bucket.s3_bucket.bucket_regional_domain_name
    origin_id   = "S3-${data.aws_s3_bucket.s3_bucket.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.storybook.id
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${data.aws_s3_bucket.s3_bucket.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# Granting CloudFront Access to S3 Bucket
resource "aws_s3_bucket_policy" "example_bucket_policy" {
  bucket = data.aws_s3_bucket.s3_bucket.bucket

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "${data.aws_s3_bucket.s3_bucket.arn}/*"
    }
  ]
}
EOF
}
