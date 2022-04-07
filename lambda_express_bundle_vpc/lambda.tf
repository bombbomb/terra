resource "aws_lambda_function" "current" {
  filename         = "${var.config["prefix"]}-${var.subdomain}-lambda.zip"
  function_name    = "${var.config["prefix"]}-${var.subdomain}"
  role             = "${var.lambda_role_arn}"
  handler          = "${var.lambda_handler}"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  runtime          = "${var.lambda_runtime}"
  memory_size      = "${var.lambda_memory_size}"
  timeout          = "${var.lambda_timeout}"
  layers           = "${var.lambda_layers}"
  environment {
    variables = "${var.lambda_environment_variables}"
  }
  vpc_config {
    security_group_ids = ["${var.lambda_security_group_ids}"]
    subnet_ids = ["${var.lambda_subnet_ids}"]
  }
}

# we need vpc of metrics server and just it's subnet

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${var.lambda_path}"
  output_path = "${var.config["prefix"]}-${var.subdomain}-lambda.zip"
  depends_on = ["null_resource.npm"]
}

resource "null_resource" "npm" {
  triggers {
    package = "${uuid()}"
  }

  provisioner "local-exec" {
    command = "cd ${var.lambda_path} && ${var.build_command}"
  }
}

resource "aws_lambda_permission" "current" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.current.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.current.id}/*/*"
}
