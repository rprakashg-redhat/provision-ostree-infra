module "deviceimages" {
    source  = "terraform-aws-modules/s3-bucket/aws"
    version = "~> 3.0"

    bucket     = var.bucket_name
    acl        = "public-read"

    # For example only
    force_destroy = true

    control_object_ownership = true
    object_ownership         = "ObjectWriter"
    block_public_acls = false
    
    # Bucket policy to allow public read access for static website
    policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::my-static-website-bucket/*"
        }
        ]
    }
    EOF
    
    tags = local.tags
}