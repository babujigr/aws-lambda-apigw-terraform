
variable "iam_role" {
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

variable "s3BucketName" {
    type = string
    default = ""
}

variable "environment" {
    type = string
    default = ""
}
