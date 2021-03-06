# Specify the Lambda function Names
s3SourceCodeBucket="bxxxx-xxx-xxxx"
environment = "dev"
s3WebSiteBucket="bx-xxxx-xxxx"
iamRoleName = "lambda_role"
apiName = "petApi"
lambda_functions = {
    example01 = {
        fileName = "example01.zip"
        handler = "main.handler"
        runtime = "nodejs12.x"
        memory = 256
        timeOut = 30
        secGroup = []
        subnetIds = []
    },
    example02 = {
        fileName = "example02.zip"
        handler = "main.handler"
        runtime = "nodejs10.x"
        memory = 256
        timeOut = 30
        secGroup = []
        subnetIds = []
    },
    example03 = {
        fileName = "example03.zip"
        handler = "main.handler"
        runtime = "nodejs10.x"
        memory = 256
        timeOut = 300
        secGroup = ["sg-xxxxxxxxxxxxxxx"]
        subnetIds = ["subnet-xxxxxx","subnet-4xxxxx"]
    },
    lambda01 = {
        fileName = "lambda01.zip"
        handler = "lambda01.lambda_handler"
        runtime = "python3.8"
        memory = 128
        timeOut = 300
        secGroup = []
        subnetIds = []
    },
    lambda02 = {
        fileName = "lambda02.zip"
        handler = "lambda02.lambda_handler"
        runtime = "python3.7"
        memory = 128
        timeOut = 30
        secGroup = []
        subnetIds = []
    },
    lambda03 = {
        fileName = "lambda03.zip"
        handler = "lambda03.lambda_handler"
        runtime = "python3.8"
        memory = 128
        timeOut = 30
        secGroup = ["sg-0xxxxx"]
        subnetIds = ["subnet-xxxa","subnet-xxxxxd"]
    }
}

# API Methods
api_resources = [
    {
      path = "example01"
      method = "GET"
      type = "AWS_PROXY"
      lambda_name = "example01"
    },
    {
      path = "example01"
      method = "OPTIONS"
      type = "MOCK"
      lambda_name = "example01"
    },
    {
      path = "example01"
      method = "POST"
      type = "AWS_PROXY"
      lambda_name = "example01"
    },
    {
      path = "lambda03"
      method = "GET"
      type = "AWS_PROXY"
      lambda_name = "lambda03"
    },
    {
      path = "lambda03"
      method = "OPTIONS"
      type = "MOCK"
      lambda_name = "lambda03"
    },
  ]
apigw_responses = [
    {
      status_code = 200
      response_templates = {
    "application/xml" = <<EOF
#set($inputRoot = $input.path('$'))
<?xml version="1.0" encoding="UTF-8"?>
<message>
    $inputRoot.body
</message>
EOF
  }
      response_models = {"application/json" = "Empty"}
      response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true
        "method.response.header.Access-Control-Allow-Methods" = true
        "method.response.header.Access-Control-Allow-Origin"  = true
        "method.response.header.Access-Control-Max-Age"       = true
      }
    }
  ]

