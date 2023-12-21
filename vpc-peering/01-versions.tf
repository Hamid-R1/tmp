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


# provider block
provider "aws" {
  region = "us-east-2"    # US East (Ohio)
  alias  = "us-east-2"    #provider = aws.us-east-2
}
