provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

module "website" {
  source             = "SPHTech-Platform/s3-cloudfront-static-site/aws"
  version            = "0.3.3"
  additional_aliases = [var.domain_name, "www.${var.domain_name}"]
  providers          = { aws.us-east-1 = aws.us-east-1 }
  bucket_name        = var.domain_name
  price_class        = "PriceClass_100"
  domains = {
    default_domain = {
      dns_zone_id         = data.aws_route53_zone.main.zone_id
      domain              = var.domain_name
      include_in_acm      = true
      create_acm_record   = true
      create_alias_record = true
    }
  }
}

