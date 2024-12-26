terraform {
  backend "s3" {
    bucket = "yash1th-backend-s3-bucket"
    key = "yash1th/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    dynamodb_table = "terraform-lock"
  }
}


