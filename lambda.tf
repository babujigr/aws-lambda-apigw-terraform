## Lambda Function Creation
module "lambda" {
source = "./modules/lambda" 

lambda_functions = var.lambda_functions
iam_role = module.iam_Role.iam_role_arn
s3BucketName = var.s3BucketName
environment = var.environment

}
