locals {
  postgres_storage_master_credentials = {
    username = data.vault_kv_secret.postgres_storage_postgres_role_credentials.data["username"]
    password = data.vault_kv_secret.postgres_storage_postgres_role_credentials.data["password"]
  }
}
