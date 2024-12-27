provider "aws" {
    region = "ap-south-1" 
}

variable "ami" {
    description = "AMI for instance"
  
}

variable "instance_type" {
    description = "Instane type for instance"
    type = map(string)
    default = {
      "dev" = "t2.micro"
      "stage" = "t2.medium"
      "prod" = "t2.xlarge"
    }
  
}

module "ec2_instances" {
    source = "./modules/ec2_instances"
    ami =  var.ami
    instance_type = lookup(var.instance_type,terraform.workspace,"t2.micro")
}