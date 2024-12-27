provider "aws" {
    region = "ap-south-1"
}

variable "cidr" {
    default = "10.0.0.0/16"
}


resource "aws_key_pair" "example" {
    key_name = "learn-key3"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr
  
}


resource "aws_subnet" "sub1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id
  
}


resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.myvpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.RT.id
  
}

resource "aws_security_group" "webSg" {
    name = "web"
    vpc_id = aws_vpc.myvpc.id
    ingress {
        description = "Http for VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Web-sg"
    }
  
}

resource "aws_instance" "server" {
    ami = "ami-053b12d3152c0cc71"
    instance_type = "t2.micro"
    key_name = aws_key_pair.example.key_name
    vpc_security_group_ids = [aws_security_group.webSg.id]
    subnet_id = aws_subnet.sub1.id
    
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host = self.public_ip
    }


    provisioner "file" {
        source = "app.py"
        destination = "/home/ubuntu/app.py"
    }

    provisioner "remote-exec" {
         inline = [
    "echo 'Hello from the remote instance'",
    "sudo apt update -y",  # Update package lists (for Ubuntu)
    "sudo apt install -y python3-full python3-pip python3-venv",  # Install Python, pip, and venv
    "cd /home/ubuntu",
    "python3 -m venv myenv",  # Create a virtual environment
    "source /home/ubuntu/myenv/bin/activate",  # Activate the virtual environment
    "/home/ubuntu/myenv/bin/pip install flask",  # Install Flask in the virtual environment
    "nohup sudo /home/ubuntu/myenv/bin/python3 /home/ubuntu/app.py > /home/ubuntu/nohup.out 2>&1 &"  # Run the app in the background with nohup
  ]
      
    }

  
}



