provider "aws" {}

resource "aws_s3_bucket" "example" {
  bucket = "cb-code-deploy-bucket-sate-test"
  acl    = "private"
}