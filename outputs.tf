output "webapp_vm_public_ip" {
  description = "Public IP address of the webapp EC2 instance"
  value = aws_instance.webapp_vm.public_ip
}

output "security_vm_public_ip" {
    description = "Public IP address of the security EC2 instance"
    value = aws_instance.security_vm.public_ip
}