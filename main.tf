provider "aws" {
    region = "ap-south-1"
}

module "ec2" {
    source = "./module/ec2"
    ami_value= "ami-053b12d3152c0cc71"
    instance_type_value= "t2.micro"
    subnet_id_value="subnet-0d9e6620bea482d31" 
}