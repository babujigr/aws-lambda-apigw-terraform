output "lambda_function_name" {
  value = {
    for lambda_function in aws_lambda_function.lambda :
    "function_name" => lambda_function.function_name...
  }
}

output "lambda_endpoints" {
  value = {
    for lambda_arn in aws_lambda_function.lambda :
    lambda_arn.function_name => lambda_arn.arn
  }
}


output "s3data" {
  value = {
    for bucketName in data.aws_s3_bucket_object.s3Objects :
    bucketName.bucket =>  bucketName.key...
  }
}