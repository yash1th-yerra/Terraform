provider "aws" {
    region = "ap-south-1"

}

provider "vault" {
    address = "http://15.206.203.37:8200"
    skip_child_token = true

    auth_login {
        path = "auth/approle/login"
        parameters = {
        role_id = "a64f71b7-d776-198f-3406-22c2efa48a29"
        secret_id = "de0274b2-bdb2-89b5-d98f-44cda8b48286"
        }
    }

}




data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name  = "test-secret"
}

resource "aws_instance" "instance" {
    instance_type = "t2.micro"
    ami = "ami-053b12d3152c0cc71"
    subnet_id = "subnet-0d9e6620bea482d31"
    tags = {
        secret = data.vault_kv_secret_v2.example.data["username"]  
    } 
}
