resource "vault_auth_backend" "approle" {
  count = local.deployment_configs.vault.count
  type  = "approle"
}

resource "vault_approle_auth_backend_role" "web_app" {
  count = local.deployment_configs.vault.count
  depends_on = [
    vault_auth_backend.approle[0]
  ]
  role_name = "web-app"
  token_policies = [
    # vault_policy.web_app[0].name
    vault_policy.all["vault/policies/web-app.policy.hcl"].name
  ]
  token_ttl          = 60
  token_max_ttl      = 4 * 60
  token_num_uses     = 3
  secret_id_num_uses = 5
  secret_id_ttl      = 60 * 60
}
