resource "vault_kv_secret" "mysql_web_app" {
  count     = local.deployment_configs.vault.count
  path      = "${vault_mount.secrets[0].path}/mysql/web-app"
  data_json = file("${var.secrets_path}/vault/secrets/mysql-web-app.secret.json")
}
