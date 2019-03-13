provider "aws" {}

terraform {
  backend "s3" {
    bucket = "${var.terrafom_s3_state}"
    region = "us-east-2"
  }
}
