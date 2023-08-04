<details>
<summary><strong>Bucket Creation</strong></summary>

The following steps detail how to create an S3 bucket for hosting the static website:

**Step 1: Provider Configuration**

The `provider.tf` file configures the AWS provider settings for the project. Update the `region` as needed.

**Step 2: Bucket Creation**

In the following block, an S3 bucket for the website is defined using the `aws_s3_bucket` resource. The bucket name is specified using the `bucketname` variable.

</details>

<details>
<summary><strong>Ownership Controls</strong></summary>

The `aws_s3_bucket_ownership_controls` resource ensures that the bucket owner has control over the objects within the bucket.

</details>

<details>
<summary><strong>Bucket Public Access</strong></summary>

The `aws_s3_bucket_public_access_block` resource is used to configure public access settings for the bucket.

</details>

<details>
<summary><strong>Bucket ACL</strong></summary>

The `aws_s3_bucket_acl` resource sets the bucket access control list to allow public-read access.

</details>

<details>
<summary><strong>Adding Objects</strong></summary>

Objects (HTML files in this case) are added to the bucket using the `aws_s3_object` resource. The `acl`, `content_type`, and other properties are specified.

</details>

<details>
<summary><strong>Website Configuration</strong></summary>

The `aws_s3_bucket_website_configuration` resource configures the S3 bucket to act as a static website. Index and error documents are specified.

</details>
