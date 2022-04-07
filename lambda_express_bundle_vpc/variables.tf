variable "config" { type = map }

variable "subdomain" {}
variable "lambda_role_arn" {}
variable "lambda_path" {}

variable "build_command" {
  default = "npm ci && npm run lighthouse-build --if-present"
}

variable "authorization" { default = "NONE" }

variable "lambda_handler" { default = "index.handler"}
variable "lambda_runtime" { default = "nodejs14.x"}
variable "lambda_memory_size" { default = "128" }
variable "lambda_timeout" { default = "30" }
variable "lambda_environment_variables" {
  type = map
  default = {
    CREATED_BY = "lambda_express_bundle_vpc"
  }
}
variable "lambda_security_group_ids" {
  type = list
}
variable "lambda_subnet_ids" {
  type = list
}
variable "description" { default = "" }

variable "request_parameters" {
  type = map
  default = {
  }
}

variable "lambda_layers" { default = [] }
