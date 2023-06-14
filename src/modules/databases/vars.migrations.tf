variable "postgres_storage_migrations_sql_tar_path" {
  type        = string
  description = "Path for the tar file for postgres storage sql migrations"
}

variable "postgres_storage_migrations_data_tar_path" {
  type        = string
  description = "Path for the tar file for postgres storage data migrations"
}

variable "postgres_storage_migrations_hash" {
  type        = string
  description = "Hash for the migrations data"
}
