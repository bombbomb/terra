resource "aws_api_gateway_method" "current" {
  rest_api_id = "${var.api_gateway_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.http_method}"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "current" {
  rest_api_id = "${var.api_gateway_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
}

resource "aws_api_gateway_integration_response" "200" {
  rest_api_id                 = "${var.api_gateway_id}"
  resource_id                 = "${var.resource_id}"
  http_method                 = "${aws_api_gateway_integration.current.http_method}"
  status_code                 = "200"
  response_templates          = { "application/json" = "" }
}

resource "aws_api_gateway_method_response" "200" {
  rest_api_id = "${var.api_gateway_id}"
  resource_id = "${var.resource_id}"
  http_method = "${aws_api_gateway_integration.current.http_method}"
  status_code = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }
}

resource "aws_api_gateway_method_response" "400" {
  rest_api_id = "${var.api_gateway_id}"
  resource_id = "${var.resource_id}"
  http_method = "${aws_api_gateway_method.current.http_method}"
  status_code = "400"
  response_models = { "application/json" = "Error" }
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }
}

resource "aws_api_gateway_method_response" "500" {
  rest_api_id = "${var.api_gateway_id}"
  resource_id = "${var.resource_id}"
  http_method = "${aws_api_gateway_method.current.http_method}"
  status_code = "500"
  response_models = { "application/json" = "Error" }
  response_parameters = { "method.response.header.Access-Control-Allow-Origin" = true }
}