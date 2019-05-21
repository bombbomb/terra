variable "config" { type = "map" }

variable "subdomain" {}
variable "lambda_role_arn" {}
variable "lambda_path" {}
variable "lambda_hash" { default = "" }

variable "authorization" { default = "NONE" }

variable "lambda_runtime" { default = "nodejs8.10"}
variable "lambda_memory_size" { default = "128" }
variable "lambda_timeout" { default = "30" }
variable "lambda_environment_variables" {
  type = "map"
  default = {
    CREATED_BY = "lambda_express_bundle"
  }
}
variable "description" { default = "" }

variable "request_parameters" {
  type = "map"
  default = {
  }
}