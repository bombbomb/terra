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
      echo "$SECRETS_JSON" | jq -r --arg env "$BRANCH" --arg repo "bombbomb/$REPO" \
        'to_entries[] | "gh secret set \(.key | @sh) --body \(.value | @sh) --env \($env | @sh) --repo \($repo | @sh)"' | sh
    EOF
    
    environment = {
      SECRETS_JSON = local.json
      REPO         = var.config["repo"]
      BRANCH       = var.config["branch"]
    }
  }
}