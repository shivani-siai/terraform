terraform {
  required_version = ">=0.13.3"
  backend "s3" {
    region = "eu-west-1"
    profile = "default"
    key = "terraform-state-file"
    bucket = "terraform-bucket-981"
  }

}