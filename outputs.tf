output "instance_ip" {
  description = "Private IP address of the imagebuilder instance"
  value = module.rhelbuilder.public_ip
}

output "instance_dns" {
  description = "Private DNS name of the imagebuilder instance"
  value = module.rhelbuilder.public_dns
}