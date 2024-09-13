module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.8.0"

  name                          = var.instanceName
  instance_count                = 1
  
  instance_type                 = var.instanceType
  ami                           = var.ami
  subnet_id                     = tolist(module.vpc.public_subnets)[0]
  key_name                      = var.sshKey
  vpc_security_group_ids        = [module.public_subnet_sg.security_group_id]
  associate_public_ip_address   = true
  ipv6_addresses = null
  private_ips = ["10.0.3.141"]
  
  iam_instance_profile = aws_iam_instance_profile.imagebuilder_instance_profile.name

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 100,
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp2"
      volume_size = 50
      encrypted   = false
    }
  ]

  tags = local.tags

  user_data = <<-EOF
    #!/bin/bash
    sudo yum -y update
    sudo dnf -y install rhel-system-roles ansible-core yum-utils
    sudo useradd -m ${var.admin_user}
    sudo usermod -aG wheel ${var.admin_user}
    sudo sed -i -e 's/^# %wheel/%wheel/' -e 's/^%wheel/# %wheel/' /etc/sudoers
    sudo sed -i -e 's/^%wheel/# %wheel/' -e 's/^# %wheel/%wheel/' /etc/sudoers
    sudo -u ${var.admin_user} mkdir -p /home/${var.admin_user}/.ssh
    sudo -u ${var.admin_user} bash -c "echo '${aws_key_pair.sshkeypair.public_key}' > /home/${var.admin_user}/.ssh/authorized_keys"
    sudo -u ${var.admin_user} ssh-keygen -t rsa -f /home/admin/.ssh/id_rsa -N ""
    sudo -u ${var.admin_user} cat .ssh/id_rsa.pub >> .ssh/authorized_keys
    sudo -u ${var.admin_user} chmod 700 /home/${var.admin_user}/.ssh
    sudo -u ${var.admin_user} chmod 600 /home/${var.admin_user}/.ssh/authorized_keys
    sudo usermod --password $(echo ${var.admin_password} | openssl passwd -1 -stdin) ${var.admin_user}
    sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    sudo systemctl restart sshd
  EOF 
}

# Create an IAM Role for EC2 to access S3
resource "aws_iam_role" "imagebuilder_access_role" {
  name = "imagebuilder_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
# Attach S3 access policy to the IAM Role
resource "aws_iam_policy" "imagebuilder_access_policy" {
  name        = "S3AccessPolicy"
  description = "Policy for EC2 to access S3 bucket ${var.bucket_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:*"
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      }
    ]
  })
}

# Attach the IAM policy to the IAM Role
resource "aws_iam_role_policy_attachment" "imagebuilder_access_policy_attachment" {
  role       = aws_iam_role.imagebuilder_access_role.name
  policy_arn = aws_iam_policy.imagebuilder_access_policy.arn
}

# Create an IAM instance profile for the EC2 instance
resource "aws_iam_instance_profile" "imagebuilder_instance_profile" {
  name = "imagebuilder_instance_profile"
  role = aws_iam_role.imagebuilder_access_role.name
}