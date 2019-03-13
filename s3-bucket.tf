provider "aws" {}

terraform {
  backend "s3" {
    bucket = "cb-code-deploy-bucket-sate-tes"
    key    = "state"
    region = "us-east-2"
  }
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "dedicated"

  tags = {
    Name = "main"
  }
}