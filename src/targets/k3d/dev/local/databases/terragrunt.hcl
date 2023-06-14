include "repo" {
  path = find_in_parent_folders("terragrunt.repo.hcl")
}

include "platform" {
  path = find_in_parent_folders("terragrunt.platform.hcl")
}

include "region" {
  path = find_in_parent_folders("terragrunt.region.hcl")
}

include "module" {
  path = join("/", [
    get_repo_root(),
    "src/modules/",
    basename(get_terragrunt_dir()),
    "terragrunt.module.hcl"
  ])
}

dependency "vault_config" {
  config_path = "../vault-config"
}

dependencies {
  paths = [
    // target-dependent
    "../k3d-cluster",

    // target-independent
    "../k8s-namespaces",
    "../k8s-config",
    "../cert-manager",
    "../vault-config"
  ]
}

locals {
  parents = {
    for parent in ["repo"] :
    parent => read_terragrunt_config(
      find_in_parent_folders("terragrunt.${parent}.hcl")
    )
  }

  artifacts_abspath    = local.parents.repo.inputs.artifacts_abspath
  project_root_abspath = local.parents.repo.inputs.project_root_abspath

  postgres_storage_migrations_sources_root_path = "${local.project_root_abspath}/notebooks/src/migrations"
  postgres_storage_migrations_sql_source_path   = "${local.postgres_storage_migrations_sources_root_path}/sql"
  postgres_storage_migrations_data_source_path  = "${local.postgres_storage_migrations_sources_root_path}/data"

  postgres_storage_migrations_source_paths = [
    local.postgres_storage_migrations_sql_source_path,
    local.postgres_storage_migrations_data_source_path,
  ]
  postgres_storage_migrations_file_list = flatten([
    for path in local.postgres_storage_migrations_source_paths :
    tolist([for filename in fileset(path, "**") :
      "${path}/${filename}"]
    )
  ])
  postgres_storage_migrations_hash = substr(
    sha256(
      join("", [
        for file in local.postgres_storage_migrations_file_list :
        filesha256(file)
      ])
    ),
    0, 10
  )

  postgres_storage_migration_artifacts_abspath = join("/", [
    local.artifacts_abspath,
    "postgres-storage"
  ])

  postgres_storage_migrations_sql_tar_path = join("", [
    local.postgres_storage_migration_artifacts_abspath,
    "/",
    "migrations-sql",
    "-",
    local.postgres_storage_migrations_hash,
    ".tar"
  ])
  postgres_storage_migrations_data_tar_path = join("", [
    local.postgres_storage_migration_artifacts_abspath,
    "/",
    "migrations-data",
    "-",
    local.postgres_storage_migrations_hash,
    ".tar"
  ])
}

inputs = {
  postgres_storage_migrations_sql_tar_path  = local.postgres_storage_migrations_sql_tar_path
  postgres_storage_migrations_data_tar_path = local.postgres_storage_migrations_data_tar_path
  postgres_storage_migrations_hash          = local.postgres_storage_migrations_hash
  vault_secrets_mount_path                  = dependency.vault_config.outputs.vault_secrets_mount_path
}

terraform {
  before_hook "create_migrations_artifacts" {
    commands = ["apply"]
    execute = [
      "scripts/create-migration-tar-files.sh",
      local.postgres_storage_migration_artifacts_abspath,
      local.postgres_storage_migrations_sql_tar_path,
      local.postgres_storage_migrations_sql_source_path,
      local.postgres_storage_migrations_data_tar_path,
      local.postgres_storage_migrations_data_source_path,
    ]
  }

  after_hook "remove_migration_tar_files" {
    commands     = ["destroy"]
    run_on_error = true
    execute = [
      "rm",
      "-rf",
      local.postgres_storage_migration_artifacts_abspath
    ]
  }
}
