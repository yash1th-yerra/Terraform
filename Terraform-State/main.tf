provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "yash1th" {
    instance_type = "t2.micro"
    ami = "ami-053b12d3152c0cc71"
    subnet_id = "subnet-0d9e6620bea482d31" 
}


resource "aws_s3_bucket" "s3_bucket" {
    bucket = "yash1th-backend-s3-bucket"
}

resource "aws_dynamodb_table" "terraform_lock" {
    name = "terraform-lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    

    attribute {
      name = "LockID"
      type = "S"
    }
  
}
