resource "vault_mount" "secrets" {
  count       = local.deployment_configs.vault.count
  path        = "secrets"
  type        = "kv"
  options     = { version = "1" }
  description = "KV version 1 secrets engine at path secrets"
}
