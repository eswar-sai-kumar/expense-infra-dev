terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0"
    }
  }
  backend "s3" {
    bucket = "s3bucket-project-devops"
    key    = "expense-dev-apps"
    region = "us-east-1"
    use_lockfile  = true
  }
}

#provide authentication here
provider "aws" {
  region = "us-east-1"
}