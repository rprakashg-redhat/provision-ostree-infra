module "deviceimages" {
    source  = "terraform-aws-modules/s3-bucket/aws"
    version = "~> 3.0"

    bucket     = var.iso_storage_bucket
    acl        = "public-read"

    # For example only
    force_destroy = true

    control_object_ownership = true
    object_ownership         = "ObjectWriter"

    attach_elb_log_delivery_policy = true
    attach_lb_log_delivery_policy  = true

    attach_deny_insecure_transport_policy = true
    attach_require_latest_tls_policy      = true
    
    block_public_acls = false

    tags = local.tags
}