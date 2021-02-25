provider "aws" {
  region = "eu-west-1"
  profile = "default"
}

#variable "subnet-cidr" {                      # Use this block when there is only one string variable - 1st Way
#  description = "Provide Subnet CIDR"
#  type = string
#}

#variable "subnet-cidr" {                      # Use this block when there is a list of variables  -  2nd Way
#  description = "Provide Subnet CIDR"
#}

variable "subnet-cidr" {                      # Use Both  -  3rd Way
  description = "Provide Subnet CIDR"
}


resource "aws_vpc" "terraform-naming-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    Name = "my-first-terraform-vpc"
  }
}

resource "aws_internet_gateway" "terraform-naming-internetgateway" {
  vpc_id = aws_vpc.terraform-naming-vpc.id
  tags = {
    Name = "my-first-terraform-internetgateway"
  }
}

resource "aws_route_table" "terraform-naming-routetable" {
  vpc_id = aws_vpc.terraform-naming-vpc.id
  tags = {
    Name = "my-first-routetable"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform-naming-internetgateway.id
  }

}


resource "aws_subnet" "terraform-naming-subnet-1" {
  cidr_block = var.subnet-cidr[0].cidr_block
  vpc_id = aws_vpc.terraform-naming-vpc.id
  tags = {
    Name = "my-first-terraform-subnet-1"
  }
  availability_zone = "eu-west-1a"
}

resource "aws_subnet" "terraform-naming-subnet-2" {
  cidr_block = var.subnet-cidr[1].cidr_block
  vpc_id = aws_vpc.terraform-naming-vpc.id
  tags = {
    Name = "my-first-terraform-subnet-2"
  }
  availability_zone = "eu-west-1a"
}


resource "aws_route_table_association" "terraform-naming-rt-association" {
  route_table_id = aws_route_table.terraform-naming-routetable.id
  subnet_id = aws_subnet.terraform-naming-subnet-1.id
}

resource "aws_security_group" "terraform-naming-sg" {
  name = "my-first-terraform-sg"
  vpc_id = aws_vpc.terraform-naming-vpc.id
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "terraform-naming-nic" {
  subnet_id = aws_subnet.terraform-naming-subnet-1.id
  private_ips = ["10.0.1.50"]
  security_groups = [aws_security_group.terraform-naming-sg.id]
}

resource "aws_eip" "terraform-naming-eip" {
  vpc = true
  network_interface = aws_network_interface.terraform-naming-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.terraform-naming-internetgateway]

}


resource "aws_instance" "terraform-naming-instance" {
  ami = "ami-06fd8a495a537da8b"
  instance_type = "t2.micro"
  availability_zone = "eu-west-1a"
  key_name = "saif-ireland"
  tags = {
    Name = "webserver-nginx"
  }
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.terraform-naming-nic.id
  }
  user_data = <<EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo This is my webpage > /var/www/html/index.html'
              EOF
}

output "webserver-nginx-public-ip" {
  value = aws_eip.terraform-naming-eip.public_ip
}