output "ec2_public_ip" {
  value = aws_instance.demo_ec2.public_ip
}

output "private_key_pem" {
  value     = tls_private_key.ec2_key.private_key_pem
  sensitive = true
}
