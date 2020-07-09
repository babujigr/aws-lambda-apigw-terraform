## CloudFront Creation
module "cloudfront" {
source = "./modules/cloudfront" 

s3BucketName = var.s3WebSiteBucket
environment = var.environment
}

