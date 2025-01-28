terraform {
  backend "s3" {
    bucket = "terra-state-main"
    key    = "websetup/terraform.tfstate"
    region = "us-east-1"
  }
}