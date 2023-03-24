terraform {
  backend "s3" {
    bucket = "gurukul-sanjeev-bucket"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"

}

data "aws_key_pair" "gurukul-2023" {
  key_name           = "Gurukul-Sanjeev"
  include_public_key = true
}

resource "aws_instance" "app_server" {
  ami                         = "ami-03c1fac8dd915ff60"
  instance_type               = "t2.micro"
  key_name                    = data.aws_key_pair.gurukul-2023.key_name
  associate_public_ip_address = true
  subnet_id = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.gurukul_2023_security_group.id]

  tags = {
    Name      = "gurukul-sanjeev"
    createdBy = "sanjeev"
  }
}

resource "aws_security_group" "gurukul_2023_security_group" {
  name        = "allow_ssh"
  vpc_id        = "vpc-019c09a1a0c5b4f6b"
  description = "Allow SSH and HTTP traffic from all sources"

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_subnet" "main" {
  vpc_id     = "vpc-019c09a1a0c5b4f6b"
  cidr_block = "10.0.0.96/28"
  tags = {
    Name = "Main"
  }
}
output "instance_ip_addr" {
  value = aws_instance.app_server.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}