locals {
  postgres_storage_vault_manager_inflation_role_credentials = {
    username = data.vault_kv_secret.postgres_storage_vault_manager_inflation_role_credentials.data["username"]
    password = data.vault_kv_secret.postgres_storage_vault_manager_inflation_role_credentials.data["password"]
  }
  postgres_storage_vault_manager_ai_education_role_credentials = {
    username = data.vault_kv_secret.postgres_storage_vault_manager_ai_education_role_credentials.data["username"]
    password = data.vault_kv_secret.postgres_storage_vault_manager_ai_education_role_credentials.data["password"]
  }
}
