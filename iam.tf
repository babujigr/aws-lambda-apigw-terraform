provider "aws" {
   region = "us-east-1"
   version = "~> 2.64.0"
 }

module "iam_Role" {
  source = "./modules/iam" 
  role_Name = var.iamRoleName
  lambda_log_name = var.iamLogName
  iam_vpc_policy_name = var.iam_vpc_policy_name

}

