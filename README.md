## Terraform S3 Bucket Creation and Static Website Hosting

This Terraform code creates an AWS S3 bucket and configures it for static website hosting.

1. **Bucket Creation**: It creates an S3 bucket with the specified name (var.bucketname).
   - Code Line: `resource "aws_s3_bucket" "mybucket" { bucket = var.bucketname }`

   > [!NOTE]  
   > **The `var.bucketname` variable is used to provide a custom name for the S3 bucket. By using a variable, you can easily change the bucket name when applying the Terraform configuration. This allows you to create multiple S3 buckets with different names without modifying the underlying code. Before running Terraform, make sure to define the `bucketname` variable in your Terraform configuration file (e.g., `variables.tf`) or pass it as an argument when executing Terraform commands (e.g., `terraform apply -var="bucketname=my-custom-bucket"`).**

2. **Ownership Controls**: It sets ownership controls on the bucket, specifying that the preferred owner of objects is the bucket owner.
   - Code Line: `resource "aws_s3_bucket_ownership_controls" "owners" { bucket = aws_s3_bucket.mybucket.id rule { object_ownership = "BucketOwnerPreferred" } }`

3. **Bucket Public Access Block**: It allows public ACLs and policies on the bucket to enable public access.
   - Code Line: `resource "aws_s3_bucket_public_access_block" "public_access" { bucket = aws_s3_bucket.mybucket.id block_public_acls = false block_public_policy = false ignore_public_acls = false restrict_public_buckets = false }`

4. **Bucket ACL to Make It Public**: The bucket's Access Control List (ACL) is set to "public-read", making all objects publicly accessible.
   - Code Line: `resource "aws_s3_bucket_acl" "acl_bucket" { depends_on = [aws_s3_bucket_ownership_controls.owners] bucket = aws_s3_bucket.mybucket.id acl = "public-read" }`

5. **Adding Objects to the Bucket**: It uploads two objects (index.html and error.html) to the bucket, both marked as publicly readable.
   - Code Lines:
     ```
     resource "aws_s3_object" "index" {
       bucket = aws_s3_bucket.mybucket.id
       key    = "index.html"
       source = "index.html"
       acl    = "public-read"
       content_type = "text/html"
       depends_on   = [aws_s3_bucket_acl.acl_bucket]
     }
     ```

     ```
     resource "aws_s3_object" "error" {
       bucket = aws_s3_bucket.mybucket.id
       key    = "error.html"
       source = "error.html"
       acl    = "public-read"
       content_type = "text/html"
       depends_on   = [aws_s3_bucket_acl.acl_bucket]
     }
     ```

6. **S3 Bucket Website Configuration**: The bucket is configured for static website hosting, with index.html as the default index document and error.html as the error document.
   - Code Line: `resource "aws_s3_bucket_website_configuration" "website" { bucket = aws_s3_bucket.mybucket.id index_document { suffix = "index.html" } error_document { key = "error.html" } depends_on = [aws_s3_bucket_acl.acl_bucket] }`

Please note that making the bucket public allows anyone to access its contents, so ensure you understand the security implications before deploying this configuration.
