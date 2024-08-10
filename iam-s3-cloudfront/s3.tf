#Create a private S3 bucket named "storybook".

# Creating S3 Bucket
resource "aws_s3_bucket" "storybook_bucket" {
  bucket = "empirestorybook"
  acl    = "private"
}


resource "aws_s3_bucket" "storybookpublic_bucket" {
  bucket = "empirestorybookpublic"
}

resource "aws_s3_bucket_public_access_block" "storybookpublic" {
  bucket = aws_s3_bucket.storybookpublic_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "storybookpublic_policy" {
  bucket = aws_s3_bucket.storybookpublic_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.storybookpublic_bucket.arn}/*"
      }
    ]
  })
}
