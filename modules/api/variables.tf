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
variable "environment" {
    type = string
    default = ""
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