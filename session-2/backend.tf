terraform {
  backend "s3" {
    bucket = "terraform-statefile-remote"
    key    = "jenkins/session-2/terraform.tfstate"
    region = "us-east-1"
  }
}