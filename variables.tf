variable "iamRoleName" {
    type = string
    default = "lambda_role"
}
variable "environment" {
    type = string
    default = ""
}

variable "iamLogName" {
    type = string
    default = "lambda_logging"
}

variable "iam_vpc_policy_name" {
    type = string
    default = "vpc_network_policy"
}

variable "s3BucketName" {
    type = string
    default = ""
}

variable "lambda_functions" {
    type = map(object({
        fileName = string
        handler = string
        runtime  = string
        memory = number
        timeOut = number
        secGroup = list(string)
        subnetIds = list(string)
        POST = string
        GET = string
  }))
}
variable "apiName" {
    type = string
    default = ""
}
variable "api_resources" {
  type = set(object({
    path   = string
    method = string
    type = string
    lambda_name = string
  })
  )
}
variable "apigw_responses" {}