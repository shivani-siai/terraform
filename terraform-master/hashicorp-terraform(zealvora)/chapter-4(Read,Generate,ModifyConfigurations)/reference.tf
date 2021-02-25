provider "aws" {
  profile = "default"
  region = "eu-west-1"
}


# attributes.tf
/*
resource "aws_eip" "terraform-eip" {
  vpc = true
}

output "eip" {
  value = aws_eip.terraform-eip.public_ip
}

resource "aws_s3_bucket" "terraform-bucket" {
  bucket = "saifbucket0038529"
}

output "s3" {
  value = aws_s3_bucket.terraform-bucket.bucket_domain_name
}
*/


resource "aws_security_group" "terraformsg" {
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
  }
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [var.publicip.myip]
  }
  tags = {
    Name: "new-sg"
  }
}

resource "aws_instance" "terraformec2" {
  ami = "ami-08a2aed6e0a6f9c7d"
  instance_type = "t2.micro"
}

resource "aws_network_interface_sg_attachment" "terrformsgattachment" {
  network_interface_id = aws_instance.terraformec2.primary_network_interface_id
  security_group_id = aws_security_group.terraformsg.id
}
#output "myip" {
#  value = var.publicip
#}