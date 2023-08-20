## Bucket Creation
# Creates an AWS S3 bucket using the specified variable for the bucket name.
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}

## Ownership Controls
# Establishes ownership controls for the S3 bucket, specifying that the bucket owner's permissions are preferred.
resource "aws_s3_bucket_ownership_controls" "owners" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

## Public Access Block
# Configures settings to control public access to the S3 bucket.
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

## Bucket ACL for Public Read Access
# Sets an Access Control List (ACL) on the S3 bucket to allow public read access.
resource "aws_s3_bucket_acl" "acl_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.owners]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

## Adding Objects to the Bucket (index.html)
# Uploads an index.html file to the S3 bucket, making it publicly accessible.
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"

  depends_on = [aws_s3_bucket_acl.acl_bucket]
}

## Adding Objects to the Bucket (error.html)
# Uploads an error.html file to the S3 bucket, making it publicly accessible.
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"

  depends_on = [aws_s3_bucket_acl.acl_bucket]
}

## S3 Bucket Website Configuration
# Configures the S3 bucket to act as a website, specifying index and error documents.
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [aws_s3_bucket_acl.acl_bucket]
}
