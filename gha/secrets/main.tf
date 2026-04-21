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
      echo "$SECRETS_JSON" | jq -r 'to_entries[] | "\(.key)\t\(.value)"' | while IFS=$'\t' read -r key value; do
        gh secret set "$key" --body "$value" --env "$BRANCH" --repo "$REPO"
      done
    EOF
    environment = {
      SECRETS_JSON = local.json
      REPO         = var.config["repo"]
      BRANCH       = var.config["branch"]
    }
  }
}