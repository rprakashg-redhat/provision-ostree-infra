module "ostree-repos" {
    source  = "terraform-aws-modules/s3-bucket/aws"
    version = "4.1.2"

    bucket      = var.ostree_bucket_name

    # For example only
    force_destroy = true

    tags = local.tags     
}

module "log_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"

  bucket = "cdnlogs-${var.stack}"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  grant = [{
    type       = "CanonicalUser"
    permission = "FULL_CONTROL"
    id         = data.aws_canonical_user_id.current.id
    }, {
    type       = "CanonicalUser"
    permission = "FULL_CONTROL"
    id         = data.aws_cloudfront_log_delivery_canonical_user_id.cloudfront.id
    # Ref. https://github.com/terraform-providers/terraform-provider-aws/issues/12512
    # Ref. https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
  }]
  force_destroy = true
}