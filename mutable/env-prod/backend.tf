terraform {
  backend "s3" {
    bucket = "terraform-teja"
    key    = "mutable/user/prod/terraform.tfstate"
    region = "us-east-1"
  }
}
