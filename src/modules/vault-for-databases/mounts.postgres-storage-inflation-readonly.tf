resource "vault_database_secrets_mount" "postgres_storage_inflation" {
  count = local.deployment_configs.postgres_storage.count
  path  = "postgres-storage/inflation"

  postgresql {
    name                     = "inflation"
    username                 = local.postgres_storage_vault_manager_inflation_role_credentials.username
    password                 = local.postgres_storage_vault_manager_inflation_role_credentials.password
    connection_url           = "${local.postgres_storage.connection_url}/inflation"
    verify_connection        = true
    root_rotation_statements = local.postgres_storage.vault_templates.common.root_rotation_statements
    allowed_roles            = local.postgres_storage_vault_roles.inflation
    max_open_connections     = 5
    max_idle_connections     = 5
    max_connection_lifetime  = 60
  }
}

resource "vault_database_secret_backend_role" "postgres_storage_inflation_readonly" {
  for_each = local.deployment_configs.postgres_storage_inflation_roles.for_each

  name    = each.key
  backend = vault_database_secrets_mount.postgres_storage_inflation.0.path
  db_name = vault_database_secrets_mount.postgres_storage_inflation.0.postgresql.0.name

  // these two clash with periodic token nature
  default_ttl = 1 * 60 * 60 // 1h
  max_ttl     = 5 * 60 * 60 // 5h 

  creation_statements = concat(
    local.postgres_storage.vault_templates.common.creation_statements,
    local.postgres_storage.vault_templates.inflation.creation_statements
  )
  revocation_statements = concat(
    local.postgres_storage.vault_templates.inflation.revocation_statements,
    local.postgres_storage.vault_templates.common.revocation_statements
  )
}
