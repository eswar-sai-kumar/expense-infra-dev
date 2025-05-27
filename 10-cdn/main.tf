resource "aws_cloudfront_distribution" "web_cdn" {
  origin {
    domain_name              =  "web-${var.environment}.${var.zone_name}"#web-dev.daws78s.online
    origin_id                = "web-${var.environment}.${var.zone_name}"
    custom_origin_config  {
        http_port              = 80 // Required to be set but not used
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = [ "TLSv1.2"]
    }
  }

  enabled             = true

  aliases = ["web-${var.common_tags.Component}.${var.zone_name}"]#web-cdn.daws78s.online

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "web-${var.environment}.${var.zone_name}"

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id  = data.aws_cloudfront_cache_policy.cache_disable.id
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/images/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "web-${var.environment}.${var.zone_name}"

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id  = data.aws_cloudfront_cache_policy.cache_enable.id
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/static/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "web-${var.environment}.${var.zone_name}"

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id  = data.aws_cloudfront_cache_policy.cache_enable.id
  }


  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "IN", "GB", "DE"]
    }
  }

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}"
    }
  )

  viewer_certificate {
    acm_certificate_arn = data.aws_ssm_parameter.acm_certificate_arn.value
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method = "sni-only"
  }
}


module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name
  
  records = [
    {
      name    = "web-cdn" #web-cdn.daws78s.online
      type    = "A"
      allow_overwrite = true
      alias   = {
        name    = aws_cloudfront_distribution.web_cdn.domain_name
        zone_id = aws_cloudfront_distribution.web_cdn.hosted_zone_id
      }
    }
  ]
}
