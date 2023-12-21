# public_ip of app-server
output "app-server-public-ip" {
  value = aws_instance.wp-app-server-1.public_ip
}
