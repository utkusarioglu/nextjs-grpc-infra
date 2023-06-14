# This requires var template "vault-secrets-mount-path" to be 
# included in the module
data "vault_kv_secret" "postgres_storage_postgres_role_credentials" {
  path = "$${var.vault_secrets_mount_path}/postgres-storage/static-roles/postgres"
}
