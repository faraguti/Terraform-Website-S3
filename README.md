<p align="center">
  <img src="https://github.com/faraguti/Terraform-Website-S3/assets/5418256/6db52534-33ee-4edd-99ef-db5468e7390d" height="100%" width="100%">
</p>

# Terraform S3 Bucket Creation and Static Website Hosting

This project demonstrates how to create and deploy a static website using Amazon S3 on AWS. The Terraform configuration in this repository automates the setup of the required resources for hosting a static website.

## Table of Contents

- [Bucket Creation](#bucket-creation)
- [Ownership Controls](#ownership-controls)
- [Bucket Public Access](#bucket-public-access)
- [Bucket ACL](#bucket-acl)
- [Adding Objects](#adding-objects)
- [Website Configuration](#website-configuration)
- [Usage](#usage)

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

<br></br>
## Usage

1. Clone the repository and navigate into it.
2. Set up Google Cloud credentials and configure the project in `provider.tf`.
3. Run `terraform init` to initialize the project.
4. Run `terraform plan` to preview changes.
5. Run `terraform apply` to deploy the database instances.
6. Access the databases using the created users.








<br></br>

## Bucket Creation

The following steps detail how to create an S3 bucket for hosting the static website:

### Step 1: Provider Configuration

The `provider.tf` file configures the AWS provider settings for the project. Update the `region` as needed.

### Step 2: Bucket Creation

In the following block, an S3 bucket for the website is defined using the `aws_s3_bucket` resource. The bucket name is specified using the `bucketname` variable.

---

## Ownership Controls

The `aws_s3_bucket_ownership_controls` resource ensures that the bucket owner has control over the objects within the bucket.

---

## Bucket Public Access

The `aws_s3_bucket_public_access_block` resource is used to configure public access settings for the bucket.

---

## Bucket ACL

The `aws_s3_bucket_acl` resource sets the bucket access control list to allow public-read access.

---

## Adding Objects

Objects (HTML files in this case) are added to the bucket using the `aws_s3_object` resource. The `acl`, `content_type`, and other properties are specified.

---

## Website Configuration

The `aws_s3_bucket_website_configuration` resource configures the S3 bucket to act as a static website. Index and error documents are specified.




