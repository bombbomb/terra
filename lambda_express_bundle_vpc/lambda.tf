resource "aws_lambda_function" "current" {
  function_name = "${var.config["prefix"]}-${var.subdomain}"
  role          = var.lambda_role_arn
  handler       = var.lambda_handler
  runtime       = lookup(var.config, "lambda_runtime", "") != "" ? var.config["lambda_runtime"] : var.lambda_runtime
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  layers        = var.lambda_layers
  environment {
    variables = var.lambda_environment_variables
  }
  vpc_config {
    security_group_ids = var.lambda_security_group_ids
    subnet_ids         = var.lambda_subnet_ids
  }

  # The GitHub Actions pipeline builds the bundle and uploads it here.
  # The key contains the commit SHA, so every deploy updates the code.
  s3_bucket = "bombbomb-github-actions"
  s3_key    = "${var.config["prefix"]}-${var.subdomain}-${var.config["commit"]}-lambda.zip"
}

resource "aws_lambda_permission" "current" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.current.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.current.id}/*/*"
}
