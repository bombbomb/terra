resource "aws_lambda_function" "current" {
  filename         = "${var.lambda_path}"
  function_name    = "${var.config["prefix"]}-${var.subdomain}"
  role             = "${var.lambda_role_arn}"
  handler          = "${var.lambda_handler}"
  source_code_hash = "${var.lambda_hash}"
  runtime          = "${var.lambda_runtime}"
  memory_size      = "${var.lambda_memory_size}"
  timeout          = "${var.lambda_timeout}"
  layers           = "${var.lambda_layers}"
  environment {
    variables = "${var.lambda_environment_variables}"
  }
}

resource "aws_lambda_permission" "current" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.current.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.current.id}/*/*"
}
