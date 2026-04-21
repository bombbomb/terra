variable "config" { type = "map" }
variable "secrets" { type = "map" }

locals {
  json = "${jsonencode(var.secrets)}"
}

resource "null_resource" "gha_secrets" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    #command = "gha secrets set --repo ${var.config.repo} --env ${var.config.branch} --json '${local.json}'"
    command = <<-EOF
        while IFS=$'\t' read -r key value; do
            echo "Key: $key, Value: $value"
            gha secrets set --repo ${var.config.repo} --env ${var.config.branch} --name "$key" --value "$value"
        done < <(echo "${local.json}" | jq -r 'to_entries[] | "\(.key)\t\(.value)"')
    EOF
  }
}