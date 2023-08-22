resource "vault_database_secrets_mount" "postgres_storage_ai_education_restricted" {
  count = local.deployment_configs.postgres_storage.count
  path  = "postgres-storage/ai-education/restricted"

  postgresql {
    name                     = "ai_education_restricted"
    username                 = local.postgres_storage_vault_manager_ai_education_role_credentials.username
    password                 = local.postgres_storage_vault_manager_ai_education_role_credentials.password
    connection_url           = "${local.postgres_storage.connection_url}/ai_education"
    verify_connection        = true
    root_rotation_statements = local.postgres_storage.vault_templates.common.root_rotation_statements
    allowed_roles            = local.postgres_storage_vault_roles.ai_education_restricted
    max_open_connections     = 5
    max_idle_connections     = 5
    max_connection_lifetime  = 60
  }
}

resource "vault_database_secret_backend_role" "postgres_storage_ai_education_restricted_readonly" {
  for_each = local.deployment_configs.postgres_storage_ai_education_restricted_roles.for_each

  name        = each.key
  backend     = vault_database_secrets_mount.postgres_storage_ai_education_restricted[0].path
  db_name     = vault_database_secrets_mount.postgres_storage_ai_education_restricted[0].postgresql[0].name
  default_ttl = 1 * 60 * 60 // 1h
  max_ttl     = 5 * 60 * 60 // 5h
  creation_statements = concat(
    local.postgres_storage.vault_templates.common.creation_statements,
    local.postgres_storage.vault_templates.ai_education_public.creation_statements,
    local.postgres_storage.vault_templates.ai_education_restricted.creation_statements
  )
  revocation_statements = concat(
    local.postgres_storage.vault_templates.ai_education_restricted.revocation_statements,
    local.postgres_storage.vault_templates.ai_education_public.revocation_statements,
    local.postgres_storage.vault_templates.common.revocation_statements
  )
}
