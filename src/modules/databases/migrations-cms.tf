resource "kubernetes_config_map" "postgres_storage_migrations_sql" {
  count = local.deployment_configs.postgres_dumps_configmap.count

  metadata {
    name      = local.postgres_storage_migrations_sql_hashed_name
    namespace = local.postgres_storage.namespace
  }

  binary_data = {
    "postgres-storage-migrations-sql.tar" = filebase64(
      var.postgres_storage_migrations_sql_tar_path
    )
  }
}

resource "kubernetes_config_map" "postgres_storage_migrations_data" {
  count = local.deployment_configs.postgres_dumps_configmap.count

  metadata {
    name      = local.postgres_storage_migrations_data_hashed_name
    namespace = local.postgres_storage.namespace
  }

  binary_data = {
    "postgres-storage-migrations-data.tar" = filebase64(
      var.postgres_storage_migrations_data_tar_path
    )
  }
}
