terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.41.0"
      
    }
  }
}
provider "aws" {
  # Configuration options
  region = "us-east-1"
  # access_key = "AKIATIRSMLQF5VKF7XWB"
  # secret_key = "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"
  
}
#creating vpc
resource "aws_vpc" "ujas-the-devops-engineer-vpc" {
  cidr_block = "10.0.0.0/16"
  tags= {
    Name = "ujas-the-devops-engineer-vpc"
  }
}
#provisioning of EC2

