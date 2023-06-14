resource "vault_policy" "all" {
  for_each = (
    local.deployment_configs.vault_config.count == 0
    ? {} :
    local.policy_records
  )
  name   = each.value.name
  policy = each.value.content
}
