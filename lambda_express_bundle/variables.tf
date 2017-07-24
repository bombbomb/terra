variable "config" { type = "map" }

variable "subdomain" {}
variable "lambda_role_arn" {}

variable "lambda_runtime" { default = "nodejs6.10"}
variable "lambda_memory_size" { default = "128" }
variable "lambda_timeout" { default = "30" }
variable "lambda_environment_variables" { type = "map" }
variable "description" { default = "" }

variable "request_parameters" {
  type = "map"
  default = {
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" { current = true }