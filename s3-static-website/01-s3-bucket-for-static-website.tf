# terraform block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.3.0"
    }
  }
}

# provider block
provider "aws" {
  region = "ap-southeast-1" #Asia Pacific (Singapore)#
}


# Create an S3 bucket for the static website
resource "aws_s3_bucket" "static_website" {
  bucket = "staticwebsite-hr-123456"

  acl    = "public-read"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

# Define a bucket policy to allow public read access to all objects
resource "aws_s3_bucket_policy" "public_access_policy" {
  bucket = aws_s3_bucket.static_website.bucket

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.static_website.arn}/*"
    }
  ]
}
POLICY
}
