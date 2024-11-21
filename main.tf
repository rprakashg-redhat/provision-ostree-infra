provider "aws" {
    region = var.region

    # Make it faster by skipping something
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_credentials_validation = true

    # skip_requesting_account_id should be disabled to generate valid ARN in apigatewayv2_api_execution_arn
    skip_requesting_account_id = false

}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_route53_zone" "this" {
  name = var.domain
}

data "aws_canonical_user_id" "current" {}
data "aws_cloudfront_log_delivery_canonical_user_id" "cloudfront" {}

#resource "aws_key_pair" "sshkeypair" {
#  key_name   = var.sshKey
#  public_key = file("~/.ssh/${var.sshKey}.pub")
#}

locals {
    #azs                     = slice(data.aws_availability_zones.available.names, 0, 3)
    #vpc_cidr                = "10.0.0.0/16" 
                
    tags = {
        stack: var.stack
    }
}