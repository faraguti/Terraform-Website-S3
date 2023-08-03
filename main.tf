## bucket creation
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}

## ownership controls
resource "aws_s3_bucket_ownership_controls" "owners" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

## making the bucket public
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


## acl to make it public
resource "aws_s3_bucket_acl" "acl_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.owners]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

## adding objects to the bucket 
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

## adding objects to the bucket 
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}

## S3 bucket website configuration resource
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  
  depends_on = [ aws_s3_bucket_acl.acl_bucket ]
}