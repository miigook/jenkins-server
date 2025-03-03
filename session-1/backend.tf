terraform {
  backend "s3" {
    bucket = "terraform-statefile-remote"
    key    = "jenkins/session-1/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}