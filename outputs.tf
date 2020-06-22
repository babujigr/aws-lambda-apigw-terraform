output "iam_role" {
  value = module.iam_Role.iam_role
}

output "iam_role_arn" {
  value = module.iam_Role.iam_role_arn
}

output "s3objects" {
  value = module.lambda.s3data
}

output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}

output "apiGateway_URL" {
  value = module.api.apiGateway_URL
}


output "lambda_endpoints" {
  value = module.lambda.lambda_endpoints
}