output "public_instance_ip" {
  value = aws_instance.web.public_ip
}

output "private_instance_ip" {
  value = aws_instance.web.private_ip
}