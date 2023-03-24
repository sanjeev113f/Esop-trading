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
  region = "us-west-2"
}

data "aws_key_pair" "gurukul-2023" {
  key_name           = "gurukul-amit"
  include_public_key = true
}

resource "aws_instance" "app_server" {
  ami                         = "ami-830c94e3"
  instance_type               = "t2.micro"
  key_name                    = data.aws_key_pair.gurukul-2023.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.gurukul_2023_security_group.id]

  tags = {
    Name      = "rrr-gurukul-Esop"
    createdBy = "sanjeev"
  }
}

resource "aws_security_group" "gurukul_2023_security_group" {

  name        = "gurukul_2023_security_group"
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

output "instance_ip_addr" {
  value = aws_instance.app_server.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}