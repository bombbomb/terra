variable "config" { type = "map" }

variable "subdomain" {}
variable "sub_subdomain" { default = "" }
variable "certificate_arn" { default = "" }
variable "lambda_role_arn" {}
variable "lambda_path" {}

variable "build_command" {
  default = "npm install && npm run lighthouse-build --if-present"
}

variable "authorization" { default = "NONE" }

variable "lambda_runtime" { default = "nodejs6.10"}
variable "lambda_memory_size" { default = "128" }
variable "lambda_timeout" { default = "30" }
variable "lambda_environment_variables" {
  type = "map"
  default = {
    CREATED_BY = "lambda_express_bundle_vpc"
  }
}
variable "lambda_security_group_ids" {
  type = "list"
}
variable "lambda_subnet_ids" {
  type = "list"
}
variable "description" { default = "" }

variable "request_parameters" {
  type = "map"
  default = {
  }
}