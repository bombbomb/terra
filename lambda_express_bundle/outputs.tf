output "lambda_arn" {
  value = "${aws_lambda_function.current.arn}"
}

output "archive_output_path" {
  value = "${path.module}/${data.archive_file.lambda_zip.output_path}"
}