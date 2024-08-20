variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "stack" {
  description = "Name of Stack"
  type        = string
  default     = "ostree-stack"
}

variable instanceName {
  description = "EC2 instance name"
  type        = string
  default     = "imagebuilder"
}

variable "instanceType" {
  description = "EC2 instance type to use"  
  type = string
  default = "m5.xlarge"
}

variable sshKey {
  description = "SSH key pair name"
  type        = string
  default     = "ec2"
}

variable "ami" {
  description = "AMI to use"
  type = string
  default = "ami-0f7197c592205b389"
}

variable "myip" {
  description = "Public IP assigned by my ISP"
  type        = string
  default     = "136.27.40.26/32"
}

variable "domain" {
  description = "Domain"
  type        = string
  default     = "sandbox1037.opentlc.com"
}

variable "admin_user" {
  description = "Default password for ec2-user account"
  type = string
  default = "admin"
}

variable "admin_password" {
  description = "Default password for ec2-user account"
  type = string
  default = "R3dh4t1!"
}
