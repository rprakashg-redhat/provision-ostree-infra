module "registry" {
    source  = "terraform-aws-modules/ecr/aws"
    version = "2.3.0"

    providers = {
      aws = aws.us-east-1
    }
    
    repository_name     = var.image_registry
    repository_type     = "public"
    
    repository_read_write_access_arns = [data.aws_caller_identity.current.arn]

    public_repository_catalog_data = {
        description       = "Container registry for ostree images"
        about_text        = file("${path.module}/files/ABOUT.md")
        usage_text        = file("${path.module}/files/USAGE.md")
        operating_systems = ["Linux", "RHEL", "RHEL For Edge"]
        architectures     = ["x86"]
        logo_image_blob   = filebase64("${path.module}/files/ostree.png")
    }

    tags = local.tags
}