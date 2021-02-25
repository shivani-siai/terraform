terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_instance" "example" {
  ami           = var.amis[var.region]
  instance_type = "t2.micro"
  #subnet_id = "subnet-23cc5b79"
  #vpc_security_group_ids = ["sg-0aea740d7f15597de"]
}

output "ip" {
  value = aws_instance.example.private_ip
}