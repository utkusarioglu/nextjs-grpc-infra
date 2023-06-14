resource "vault_kv_secret" "grafana_admin" {
  path      = "${vault_mount.secrets[0].path}/grafana/users/admin"
  data_json = file("${var.secrets_abspath}/vault/secrets/grafana-admin.json")
}
