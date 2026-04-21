variable "config" { type = map(string) }
variable "secrets" { type = map(string) }

locals {
  json = "${jsonencode(var.secrets)}"
}

resource "null_resource" "gha_secrets" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<-EOF
        touch .env
        echo "${local.json}" > .env
        gh secrets set --repo bombbomb/${var.config.repo} --env ${var.config.branch} -f .env
    EOF
  }
}