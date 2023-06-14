# This requires var template "vault-secrets-mount-path" to be 
# included in the module
data "vault_kv_secret" "postgres_storage_vault_manager_inflation_role_credentials" {
  path = "$${var.vault_secrets_mount_path}/postgres-storage/static-roles/vault-manager-inflation"
}

data "vault_kv_secret" "postgres_storage_vault_manager_ai_education_role_credentials" {
  path = "$${var.vault_secrets_mount_path}/postgres-storage/static-roles/vault-manager-ai-education"
}
