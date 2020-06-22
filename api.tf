## API Gateway Creation & Deployment

module "api" {
source = "./modules/api" 

lambda_functions = var.lambda_functions
environment = var.environment
apiName = "${var.apiName}-${var.environment}"
api_resources = var.api_resources
apigw_responses = var.apigw_responses
}