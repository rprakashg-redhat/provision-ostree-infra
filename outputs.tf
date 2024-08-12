output "bastion_ip" {
  description = "Public IP of Bastion node"
  value = module.bastion.public_ip
}

output "bastion_dns" {
  description = "Public DNS name of bastion node"
  value = module.bastion.public_dns
}

output "imagebuilder_ip" {
  description = "Private IP address of the EC2 instance"
  value = module.ec2.private_ip
}

output "imagebuilder_dns" {
  description = "Private DNS name of the EC2 instance"
  value = module.ec2.private_dns
}