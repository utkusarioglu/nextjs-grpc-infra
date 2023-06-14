resource "vault_auth_backend" "userpass" {
  count = local.deployment_configs.vault_config.count
  type  = "userpass"
}

resource "vault_generic_endpoint" "userpass" {
  for_each = (
    local.deployment_configs.vault_config.count == 0
    ? {}
    : local.userpass_records
  )
  path = join("/", [
    "auth",
    vault_auth_backend.userpass[0].path,
    "users",
    each.value.name
  ])
  ignore_absent_fields = true

  data_json = each.value.content

  depends_on = [
    vault_auth_backend.userpass[0]
  ]
}
