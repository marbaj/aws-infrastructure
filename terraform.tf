provider "aws" {}

terraform {
  backend "s3" {
    bucket = "b-code-deploy-bucket-sate-test"
    key    = "state"
    region = "us-east-2"
  }
}

variable "account" {}

module "codebuild-infrastructure" {
  source    = "./codebuild",
  repo = "https://github.com/marbaj/aws-infrastructure.git"
  account = "${var.account}"
}

module "vpc-main" {
  source    = "./vpc",
  account = "${var.account}"
}
