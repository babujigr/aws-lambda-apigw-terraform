
data "aws_lambda_function" "lambda" {
  for_each = var.lambda_functions
  function_name = "${each.key}-${var.environment}"
  depends_on = [
    var.lambda_function_ids
  ]
}

# API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name = var.apiName
}

locals {
  deployed_at = formatdate("DD-MMM-YYYY hh-mm-ss ZZZ",timestamp())
  response_codes = toset(var.apigw_responses)

  # endpoints is a set of all of the distinct paths in var.endpoints
  api_resources = toset(var.api_resources.*.path)

  # methods is a map from method+path identifier strings to endpoint definitions
  methods = {
    for e in var.api_resources : "${e.method} ${e.path}" => {
      path = e.path
      method = e.method
      type = e.type
      lambda_name = "${e.lambda_name}-${var.environment}"
      uri = data.aws_lambda_function.lambda[e.lambda_name].invoke_arn
      arn = data.aws_lambda_function.lambda[e.lambda_name].arn
    }
  }

  # responses is a map from method+path+status_code identifier strings
  # to endpoint definitions
  responses = {
    for pair in setproduct(var.api_resources, local.response_codes) :
    "${pair[0].method} ${pair[0].path} ${pair[1].status_code}" => {
      method              = pair[0].method
      path                = pair[0].path
      lambda_name         = "${pair[0].path}-${var.environment}"
      type                = pair[0].type
      method_key          = "${pair[0].method} ${pair[0].path}" # key for local.methods
      status_code         = pair[1].status_code
      response_templates  = pair[1].response_templates
      response_models     = pair[1].response_models
      response_parameters = pair[1].response_parameters
    }
  }
}

resource "aws_api_gateway_resource" "resource" {
  for_each = local.api_resources
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
  path_part   = each.value
}

resource "aws_api_gateway_method" "rs_method" {
  for_each = local.methods

  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource[each.value.path].id
  http_method = each.value.method
  authorization = "NONE"
  depends_on = [
    aws_api_gateway_resource.resource,
  ]
}

resource "aws_api_gateway_method_response" "resp_method" {
  for_each = local.responses

  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource[each.value.path].id
  http_method = each.value.method
  status_code = "200"
  
  response_models = each.value.response_models
    depends_on = [
    aws_api_gateway_method.rs_method
  ]

}

resource "aws_api_gateway_integration" "rs_integration" {
  for_each = local.methods

  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource[each.value.path].id
  http_method = aws_api_gateway_method.rs_method[each.key].http_method

  type                    = each.value.type
  integration_http_method = each.value.type == "MOCK" ? null : "POST"
  uri                     = each.value.type == "MOCK" ? null : each.value.uri
}

resource "aws_api_gateway_integration_response" "intg_res" {
  for_each = local.responses
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource[each.value.path].id
  http_method = each.value.method
  status_code = each.value.status_code
    depends_on = [
    aws_api_gateway_method.rs_method,
    aws_api_gateway_integration.rs_integration
  ]

  response_templates = each.value.response_templates != null ? each.value.response_templates : null

}

resource "aws_lambda_permission" "apigw_lambda_permission" {
  for_each = local.methods
  action        = "lambda:InvokeFunction"
  function_name = each.value.arn
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_deployment" "api_deploy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name = var.environment
  description = "${var.environment} deployed at ${local.deployed_at}"
  depends_on = [
    aws_api_gateway_integration.rs_integration,
    aws_lambda_permission.apigw_lambda_permission,
    aws_api_gateway_method.rs_method
    ]
  lifecycle {
    create_before_destroy = true
  }
}