module "elb" {
    source  = "terraform-aws-modules/elb/aws"
    version = "4.0.2"

    name = "${var.stack}-elb"
    subnets = module.vpc.public_subnets
    health_check = {
        target              = "TCP:80"
        interval            = 30
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 5
    }
    listener = [
        {
            instance_port     = "9090"
            instance_protocol = "HTTPS"
            lb_port           = "443"
            lb_protocol       = "HTTPS"
            ssl_certificate_id  = aws_acm_certificate.cert.id
        },
    ]
    security_groups = [module.public_subnet_sg.security_group_id]

    # ELB attachments
    number_of_instances = 1
    instances           = module.ec2.id

}