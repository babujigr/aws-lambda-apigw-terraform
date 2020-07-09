resource "aws_s3_bucket" "webBucket" {
  bucket = var.s3BucketName
  acl    = "private"

  tags = {
    Environment = var.environment
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access-identity-${var.s3BucketName}"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.webBucket.bucket_domain_name
    origin_id   = var.s3BucketName

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Test CDN Distribution"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3BucketName

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"
  
  restrictions {
      geo_restriction {
      restriction_type = "none"
    }
  }
  tags = {
    Environment = var.environment
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.webBucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.webBucket.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
  depends_on = [
    aws_cloudfront_distribution.s3_distribution,
    aws_s3_bucket.webBucket,
  ]

}

resource "aws_s3_bucket_policy" "s3bucketpolicy" {
  bucket = aws_s3_bucket.webBucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
  depends_on = [
    aws_cloudfront_distribution.s3_distribution,
    aws_s3_bucket.webBucket,
  ]

}