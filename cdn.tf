module "cloudfront" {
    source  = "terraform-aws-modules/cloudfront/aws"
    version = "3.4.1"
    
    enabled             = true
    aliases             = ["${var.subdomain}.${var.domain}"]
    staging             = false
    http_version        = "http2and3"     
    is_ipv6_enabled     = false
    price_class         = "PriceClass_All"
    retain_on_delete    = false
    wait_for_deployment = false

    continuous_deployment_policy_id = null

    create_origin_access_identity = true
    origin_access_identities = {
        s3_oai = "S3 Origin Access Identity for Cloudfront"
    }

    origin = {
        s3 = {
            domain_name = module.ostree-repos.s3_bucket_bucket_regional_domain_name
            s3_origin_config = {
                origin_access_identity = "s3_oai" # key in `origin_access_identities`
            }
        }
    }

    default_cache_behavior = {
        path_pattern           = "/*"
        target_origin_id       = "s3"
        viewer_protocol_policy = "allow-all"
        allowed_methods        = ["GET", "HEAD", "OPTIONS"]
        cached_methods         = ["GET", "HEAD"]
    }

    viewer_certificate = {
        acm_certificate_arn = module.acm.acm_certificate_arn
        ssl_support_method  = "sni-only"
    }

    logging_config = {
      bucket = module.log_bucket.s3_bucket_bucket_domain_name
      prefix = "cloudfront"
    }
}

data "aws_iam_policy_document" "s3_policy" {
  # Origin Access Identities
  statement {
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = [
        "${module.ostree-repos.s3_bucket_arn}", "${module.ostree-repos.s3_bucket_arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = module.cloudfront.cloudfront_origin_access_identity_iam_arns
    }
  }

  # Origin Access Controls
  statement {
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = [
        "${module.ostree-repos.s3_bucket_arn}",
        "${module.ostree-repos.s3_bucket_arn}/*"
    ]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [module.cloudfront.cloudfront_distribution_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.ostree-repos.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_policy.json
}