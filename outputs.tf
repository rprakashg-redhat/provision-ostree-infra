output "instance_ip" {
  description = "Private IP address of the EC2 instance"
  value = module.ec2.public_ip
}

output "instance_dns" {
  description = "Private DNS name of the EC2 instance"
  value = module.ec2.public_dns
}