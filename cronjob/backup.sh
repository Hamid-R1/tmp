#!/bin/bash

# Set the source directory on the EC2 instance that you want to backup
SOURCE_DIR="/home/ec2-user/data/"

# Set the S3 bucket name and target directory where you want to copy the data
S3_BUCKET="abc-data-store-bucket"
TARGET_DIR="user-data/ec2-user/"

# Run the AWS CLI command to copy the data from the source directory to the S3 bucket
aws s3 cp ${SOURCE_DIR} s3://${S3_BUCKET}/${TARGET_DIR} --recursive
