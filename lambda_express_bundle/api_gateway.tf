data "aws_caller_identity" "current" {}
data "aws_region" "current" { current = true }
data "aws_iam_role" "lambda_role" { role_name = "${var.config["prefix"]}-AppRole" }

# API Gateway
resource "aws_api_gateway_rest_api" "current" {
  name        = "${var.config["prefix"]}-${var.subdomain}"
  description = "${var.description}"
}

resource "aws_api_gateway_resource" "all_paths" {
  rest_api_id = "${aws_api_gateway_rest_api.current.id}"
  parent_id   = "${aws_api_gateway_rest_api.current.root_resource_id}"
  path_part   = "{proxy+}"
}

module "all_paths_proxy" {
  source = "github.com/bombbomb/terra//lambda_express"
  api_gateway_id = "${aws_api_gateway_rest_api.current.id}"
  resource_id = "${aws_api_gateway_resource.all_paths.id}"
  http_method = "ANY"
  lambda_arn = "${aws_lambda_function.current.arn}"
}

resource "aws_api_gateway_deployment" "current" {
  depends_on = ["module.all_paths_proxy"]
  rest_api_id = "${aws_api_gateway_rest_api.current.id}"
  stage_name  = "${var.config["branch"]}"
  description = "Deployed at ${timestamp()}"
  stage_description = "Deployed at ${timestamp()}"

  # Necessary to work with custom domain
  lifecycle {
    create_before_destroy = true
  }

}

data "aws_acm_certificate" "selected" {
  domain   = "*.bombbomb.io"
  statuses = ["ISSUED"]
}

resource "aws_api_gateway_domain_name" "current" {
  domain_name = "${var.config["branch"] == "master" ? "${var.subdomain}.bombbomb.io" : "${var.config["branch"]}-${var.subdomain}.dev.bombbomb.io" }"
  certificate_arn = "${data.aws_acm_certificate.selected.arn}"
}

resource "aws_route53_record" "current" {
  zone_id = "${var.config["app_zone_id"]}"
  name = "${aws_api_gateway_domain_name.current.domain_name}"
  type = "A"

  alias {
    name = "${aws_api_gateway_domain_name.current.cloudfront_domain_name}"
    zone_id = "${aws_api_gateway_domain_name.current.cloudfront_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_api_gateway_base_path_mapping" "current" {
  api_id      = "${aws_api_gateway_rest_api.current.id}"
  stage_name  = "${aws_api_gateway_deployment.current.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.current.domain_name}"
}

resource "aws_api_gateway_method" "current" {
  rest_api_id = "${aws_api_gateway_rest_api.current.id}"
  resource_id = "${aws_api_gateway_rest_api.current.root_resource_id}"
  http_method = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "current" {
  rest_api_id = "${aws_api_gateway_rest_api.current.id}"
  resource_id = "${aws_api_gateway_rest_api.current.root_resource_id}"
  http_method = "ANY"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.current.arn}/invocations"
}

resource "aws_api_gateway_integration_response" "200" {
  rest_api_id = "${aws_api_gateway_rest_api.current.id}"
  resource_id = "${aws_api_gateway_rest_api.current.root_resource_id}"
  http_method                 = "${aws_api_gateway_integration.current.http_method}"
  status_code                 = "200"
  response_templates          = { "application/json" = "" }
}

resource "aws_api_gateway_method_response" "200" {
  rest_api_id = "${aws_api_gateway_rest_api.current.id}"
  resource_id = "${aws_api_gateway_rest_api.current.root_resource_id}"
  http_method = "${aws_api_gateway_integration.current.http_method}"
  status_code = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }
}

resource "aws_api_gateway_method_response" "400" {
  rest_api_id = "${aws_api_gateway_rest_api.current.id}"
  resource_id = "${aws_api_gateway_rest_api.current.root_resource_id}"
  http_method = "${aws_api_gateway_method.current.http_method}"
  status_code = "400"
  response_models = { "application/json" = "Error" }
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }
}

resource "aws_api_gateway_method_response" "500" {
  rest_api_id = "${aws_api_gateway_rest_api.current.id}"
  resource_id = "${aws_api_gateway_rest_api.current.root_resource_id}"
  http_method = "${aws_api_gateway_method.current.http_method}"
  status_code = "500"
  response_models = { "application/json" = "Error" }
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }
}