// TODO the implementation here for `notebooks-restricted-readonly` is
// not scalable. a better method is needed
resource "vault_identity_entity" "userpass" {
  for_each = (
    local.deployment_configs.vault_config.count == 0
    ? {}
    : local.userpass_records
  )

  name = each.value.name
  policies = (each.value.name == "notebooks-restricted-readonly"
    ? ["postgres_storage_ai_education_restricted_entity"]
    : []
  )
  # policies = jsondecode(each.value.content).policies
  metadata = {
    something = "some value"
    rel_path  = each.value.rel_path
  }
}

resource "vault_identity_entity_alias" "userpass" {
  for_each = (
    local.deployment_configs.vault_config.count == 0
    ? {}
    : local.userpass_records
  )
  name           = each.value.name
  mount_accessor = vault_auth_backend.userpass[0].accessor
  canonical_id   = vault_identity_entity.userpass[each.value.rel_path].id
}
