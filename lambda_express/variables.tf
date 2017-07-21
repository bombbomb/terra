variable "api_gateway_id" {}
variable "resource_id" {}
variable "lambda_arn" {}

variable "http_method" {
  default = "ANY"
}

variable "request_parameters" {
  type = "map"
  default = {

  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" { current = true }