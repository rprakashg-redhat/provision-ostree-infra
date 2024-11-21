#output "imagebuilder_ip" {
#  description = "Public IP address of the EC2 instance"
#  value = module.ec2.public_ip
#}

#output "imagebuilder_dns" {
#  description = "Public DNS name of the EC2 instance"
#  value = module.ec2.public_dns
#}

output "cloudfront_domain" {
  description = "Cloudfront domain"
  value = module.cloudfront.cloudfront_distribution_domain_name
}