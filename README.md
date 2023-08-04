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

## Bucket Creation

The following steps detail how to create an S3 bucket for hosting the static website:

### Step 1: Provider Configuration

The `provider.tf` file configures the AWS provider settings for the project. Update the `region` as needed.
```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.10.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-west-2"
}
```

### Step 2: Bucket Creation

In the `main.tf` file, an S3 bucket for the website is defined using the `aws_s3_bucket` resource. The bucket name is specified using the `bucketname` variable.
```
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}
```

> [!NOTE]  
> ***The `var.bucketname` variable is used to provide a custom name for the S3 bucket. By using a variable, you can easily change the bucket name when applying the Terraform configuration. This allows you to create multiple S3 buckets with different names without modifying the underlying code. Before running Terraform, make sure to define the `bucketname` variable in your Terraform configuration file (e.g., `variables.tf`) or pass it as an argument when executing Terraform commands (e.g., `terraform apply -var="bucketname=my-custom-bucket"`).***

---

## Ownership Controls

The `aws_s3_bucket_ownership_controls` resource ensures that the bucket owner has control over the objects within the bucket.
```
resource "aws_s3_bucket_ownership_controls" "owners" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
```

---

## Bucket Public Access

The `aws_s3_bucket_public_access_block` resource is used to configure public access settings for the bucket.
```
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
```

---

## Bucket ACL

The `aws_s3_bucket_acl` resource sets the bucket access control list to allow public-read access.
```
resource "aws_s3_bucket_acl" "acl_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.owners]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}
```

---

## Adding Objects

Objects (HTML files in this case) are added to the bucket using the `aws_s3_object` resource. The `acl`, `content_type`, and other properties are specified. The files are marked as publicly readable.
```
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"

  depends_on = [ aws_s3_bucket_acl.acl_bucket ]
}

## adding objects to the bucket 
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"

  depends_on = [ aws_s3_bucket_acl.acl_bucket ]
}
```
---

## Website Configuration

The `aws_s3_bucket_website_configuration` resource configures the S3 bucket to act as a static website, with index.html as the default index document and error.html as the error document.
```
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
```

> [!NOTE]  
> ***The `depends_on` attribute is used to specify explicit dependencies between resources. It ensures that certain resources are created or updated before others. In this configuration, the `depends_on` attribute is applied to certain resources to manage the order of operations.***

For example:
- The `aws_s3_bucket_acl` resources for `index.html` and `error.html` objects depend on the `aws_s3_bucket_ownership_controls` resource. This ensures that the ownership controls are established before setting the ACLs for the objects, as per AWS requirements.

- The `aws_s3_object` resources for `index.html` and `error.html` depend on the `aws_s3_bucket_acl` resources for the same objects. This guarantees that the proper ACL configurations are applied before uploading the objects to the S3 bucket.

- The `aws_s3_bucket_website_configuration` resource depends on the `aws_s3_bucket_acl` resource. This ensures that the bucket's ACL configuration is completed before enabling static website hosting.

Using `depends_on`, makes Terraform enforces a specific sequence of operations, helping to avoid potential resource creation or configuration conflicts.**

<br></br>
## Usage

1. Clone the repository and navigate into it.
2. Set up AWS credentials.
3. Run `terraform init` to initialize the project.
4. Run `terraform plan` to preview changes.
5. Run `terraform apply` to create the S3 Bucket.
 



