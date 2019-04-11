variable "config" { type = "map" }
variable "name" { type = "string" }
variable "value" { type = "string" }

locals {
  json_line = "{ \"value\": \"${var.value}\" }"
  url = "${var.config["lighthouse_url"]}/v1/apps/${var.config["app"]}/${var.config["prefix"]}/secrets/${var.name}"
  user = "${var.config["lighthouse_user"]}:${var.config["lighthouse_password"]}"
}

resource "null_resource" "api_call" {
  provisioner "local-exec" {
    command = "curl -f --user ${local.user} -H \"Content-Type: application/json\" -d '${local.json_line}' -X PUT ${local.url}"
  }
}