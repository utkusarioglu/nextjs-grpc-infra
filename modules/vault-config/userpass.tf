resource "vault_auth_backend" "userpass" {
  count = local.deployment_configs.vault.count
  type  = "userpass"
}

resource "vault_generic_endpoint" "userpass" {
  for_each = (
    local.deployment_configs.vault.count == 0
    ? []
    : fileset("${var.secrets_path}", "/vault/userpasses/*.userpass.json")
  )
  path                 = "auth/${vault_auth_backend.userpass[0].path}/users/${trimsuffix(basename(each.key), ".userpass.json")}"
  ignore_absent_fields = true

  # count                = local.deployment_configs.vault.count
  # data_json = <<-EOT
  # {
  #   "policies": ["admin", "eaas-client"],
  #   "password": "pass1"
  # }
  # EOT
  data_json = file("${var.secrets_path}/${each.key}")

  depends_on = [
    vault_auth_backend.userpass[0]
  ]
}
