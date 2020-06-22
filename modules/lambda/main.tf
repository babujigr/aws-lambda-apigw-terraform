
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}


data "aws_s3_bucket_object" "s3Objects" {
  for_each = var.lambda_functions
  bucket = var.s3BucketName
  key = each.value["fileName"]
}
 resource "aws_lambda_function" "lambda" {
   for_each = var.lambda_functions
   function_name = "${each.key}-${var.environment}"

   handler = each.value["handler"]
   runtime = each.value["runtime"]
   memory_size = each.value["memory"]
   timeout = each.value["timeOut"]
   role = var.iam_role
   s3_bucket = data.aws_s3_bucket_object.s3Objects[each.key].bucket
   s3_key = data.aws_s3_bucket_object.s3Objects[each.key].key
   s3_object_version = data.aws_s3_bucket_object.s3Objects[each.key].version_id
   vpc_config {
      subnet_ids = each.value["subnetIds"]
      security_group_ids = each.value["secGroup"]
    }

 }