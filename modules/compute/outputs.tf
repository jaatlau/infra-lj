output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.main.id
}

output "public_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.main.public_ip
}