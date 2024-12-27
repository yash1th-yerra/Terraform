provider "aws" {
    region = "ap-south-1"
}


variable "ami" {
    description = "This is ami for instance"
 
  
}

variable "instance_type" {
    description = "This is instance type for instance"
  
}

resource "aws_instance" "example" {
    ami = var.ami
    instance_type = var.instance_type
}