locals {
  postgres_storage_migrations_sql_hashed_name = join("-", [
    "postgres-storage-migrations-sql-tar",
    var.postgres_storage_migrations_hash
  ])
  postgres_storage_migrations_data_hashed_name = join("-", [
    "postgres-storage-migrations-data-tar",
    var.postgres_storage_migrations_hash
  ])
}
