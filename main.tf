provider "aws" {
  region = "us-east-1"
}

# Fetch latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Generate SSH key dynamically
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair
resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-github-actions-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# Creating EC2 instance
resource "aws_instance" "demo_ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.terraform_key.key_name

  tags = {
    Name = "terraform-github-actions-ec2"
  }
}
