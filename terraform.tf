provider "aws" {}

terraform {
  backend "s3" {
    bucket = "cb-terraform-state-dsfsdfsdfs"
    key    = "state"
    region = "us-east-2"
  }
}


module "codebuild-infrastructure" {
  source    = "./codebuild",
  repo = "https://github.com/marbaj/aws-infrastructure.git"
  account = "dev"
}
