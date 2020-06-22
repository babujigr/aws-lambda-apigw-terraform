
output "apiGateway_URL" {
  value = {
      endpoint =  aws_api_gateway_deployment.api_deploy.invoke_url
  }
}

/* output "lambda_endpoints" {
 value = {
    for endpoint in data.aws_lambda_function.lambda :
    endpoint.function_name =>  endpoint.arn
 }
}
*/