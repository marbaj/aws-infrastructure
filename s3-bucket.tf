provider "aws" {}

terraform {
  backend "s3" {
    bucket = "cb-code-deploy-bucket-sate-test"
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


# resource "aws_subnet" "main" {
#   vpc_id     = "${aws_vpc.main.id}"
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name = "Main"
#   }
# }