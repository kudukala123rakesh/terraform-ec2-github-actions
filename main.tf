provider "aws" {
  region = "us-east-1"
}

# Generate SSH key dynamically
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair using generated public key
resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-github-actions-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# Create EC2 instance
resource "aws_instance" "demo_ec2" {
  ami           = "ami-0d8f6eb4f641ef691" # Amazon Linux 2 (eu-north-1)
  instance_type = "t3.micro"
  key_name      = aws_key_pair.terraform_key.key_name

  tags = {
    Name = "terraform-github-actions-ec2"
  }
