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
