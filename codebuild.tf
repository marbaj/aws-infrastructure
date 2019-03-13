provider "aws" {}

terraform {
  backend "s3" {
    bucket = "${var.terrafom_s3_state}"
    key    = "state"
    region = "us-east-2"
  }
}

resource "aws_s3_bucket" "infrastructure" {
  bucket = "${var.terrafom_s3_state}"
  acl    = "private"
}

resource "aws_iam_role" "infrastructure" {
  name = "infrastructure"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "infrastructure" {

  role = "${aws_iam_role.infrastructure.name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.infrastructure.arn}",
        "${aws_s3_bucket.infrastructure.arn}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "infrastructure" {
  name          = "infrastructure-build"
  description   = "test_codebuild_project"
  build_timeout = "5"
  service_role  = "${aws_iam_role.infrastructure.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = "${aws_s3_bucket.infrastructure.bucket}"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "hashicorp/terraform"
    type         = "LINUX_CONTAINER"
  }

    environment_variable {
      "account"  = "dev"
    }

  source {
    type            = "GITHUB"
    location        = "https://github.com/marbaj/aws-infrastructure.git"
    git_clone_depth = 1
  }

  tags = {
    "Environment" = "dev"
  }
}
