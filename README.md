<p align="center">
  <img src="https://github.com/faraguti/Terraform-Website-S3/assets/5418256/6db52534-33ee-4edd-99ef-db5468e7390d" height="100%" width="100%">
</p>

## Terraform S3 Bucket Creation and Static Website Hosting

This Terraform code creates an AWS S3 bucket and configures it for static website hosting.

1. **Bucket Creation**: It creates an S3 bucket with the specified name (var.bucketname).
   - Code Line: `resource "aws_s3_bucket" "mybucket" { bucket = var.bucketname }`
     <br></br>

   > [!NOTE]  
   > ***The `var.bucketname` variable is used to provide a custom name for the S3 bucket. By using a variable, you can easily change the bucket name when applying the Terraform configuration. This allows you to create multiple S3 buckets with different names without modifying the underlying code. Before running Terraform, make sure to define the `bucketname` variable in your Terraform configuration file (e.g., `variables.tf`) or pass it as an argument when executing Terraform commands (e.g., `terraform apply -var="bucketname=my-custom-bucket"`).***

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
      <br></br>

   > [!NOTE]  
   > ***The `depends_on` attribute is used to specify explicit dependencies between resources. It ensures that certain resources are created or updated before others. In this configuration, the `depends_on` attribute is applied to certain resources to manage the order of operations.***

   For example:
   - The `aws_s3_bucket_acl` resources for `index.html` and `error.html` objects depend on the `aws_s3_bucket_ownership_controls` resource. This ensures that the ownership controls are established before setting the ACLs for the objects, as per AWS requirements.
   
   - The `aws_s3_object` resources for `index.html` and `error.html` depend on the `aws_s3_bucket_acl` resources for the same objects. This guarantees that the proper ACL configurations are applied before uploading the objects to the S3 bucket.
   
   - The `aws_s3_bucket_website_configuration` resource depends on the `aws_s3_bucket_acl` resource. This ensures that the bucket's ACL configuration is completed before enabling static website hosting.

   Using `depends_on`, makes Terraform enforces a specific sequence of operations, helping to avoid potential resource creation or configuration conflicts.**

Please note that making the bucket public allows anyone to access its contents, so ensure you understand the security implications before deploying this configuration.
