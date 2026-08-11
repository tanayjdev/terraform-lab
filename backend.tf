terraform {
  backend "s3" {
    bucket         = "tanayjdev-tf-state-2026-464975960111"
    key            = "terraform-mastery/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
