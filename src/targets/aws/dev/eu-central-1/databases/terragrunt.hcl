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
    "../aws-eks",

    // target-independent
    "../k8s-namespaces",
    "../k8s-config",
    "../cert-manager",
    "../vault-config",
  ]
}

locals {
  parents = {
    for parent in ["repo", "region"] :
    parent => read_terragrunt_config(
      find_in_parent_folders("terragrunt.${parent}.hcl")
    )
  }

  region            = local.parents.region.inputs.region
  aws_profile       = local.parents.region.inputs.aws_profile
  region_identifier = local.parents.region.inputs.region_identifier
  cluster_name      = local.parents.region.inputs.cluster_name

  target_identifier = concat(local.region_identifier, [
    basename(get_terragrunt_dir())
  ])
  target_name = join("-", local.target_identifier)
  s3_key      = join("/", concat(local.target_identifier, ["terraform.tfstate"]))

  remote_state_config = {
    bucket         = local.target_name
    key            = local.s3_key
    region         = local.region
    encrypt        = true
    dynamodb_table = local.target_name
    profile        = local.aws_profile
  }

  config_templates = {
    backends = [
      {
        name = "aws"
        args = local.remote_state_config
      }
    ]
    providers = [
      {
        name = "aws-helm-kubernetes"
        args = {
          cluster_name = local.cluster_name
        }
      }
    ]
  }

  artifacts_abspath    = local.parents.repo.inputs.artifacts_abspath
  project_root_abspath = local.parents.repo.inputs.project_root_abspath

  // postgres_storage_migrations_sql_tar_path    = "${local.artifacts_abspath}/postgres-storage-migrations-sql.tar"
  // postgres_storage_migrations_sql_source_path = "${local.project_root_abspath}/notebooks/src/migrations/sql"

  // postgres_storage_migrations_data_tar_path    = "${local.artifacts_abspath}/postgres-storage-migrations-data.tar"
  // postgres_storage_migrations_data_source_path = "${local.project_root_abspath}/notebooks/src/migrations/data"

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

remote_state {
  backend = "s3"
  config  = local.remote_state_config
}

generate "generated_config_target" {
  path      = "generated-config.target.tf"
  if_exists = "overwrite"
  contents = join("\n", ([
    for key, items in local.config_templates :
    (join("\n", [
      for j, template in items :
      templatefile(
        "${get_repo_root()}/src/templates/${key}/${template.name}.tftpl.hcl",
        try(template.args, {})
      )
    ]))
  ]))
}

inputs = {
  // postgres_storage_migrations_sql_tar_path  = local.postgres_storage_migrations_sql_tar_path
  // postgres_storage_migrations_data_tar_path = local.postgres_storage_migrations_data_tar_path
  postgres_storage_migrations_sql_tar_path  = local.postgres_storage_migrations_sql_tar_path
  postgres_storage_migrations_data_tar_path = local.postgres_storage_migrations_data_tar_path
  postgres_storage_migrations_hash          = local.postgres_storage_migrations_hash
  vault_secrets_mount_path                  = dependency.vault_config.outputs.vault_secrets_mount_path
}

terraform {
  // before_hook "create_migrations_sql_tar" {
  //   commands = ["apply"]
  //   execute = [
  //     "tar",
  //     "-zcvf",
  //     local.postgres_storage_migrations_sql_tar_path,
  //     "-C",
  //     local.postgres_storage_migrations_sql_source_path,
  //     "."
  //   ]
  // }

  // before_hook "create_migrations_data_tar" {
  //   commands = ["apply"]
  //   execute = [
  //     "tar",
  //     "-zcvf",
  //     local.postgres_storage_migrations_data_tar_path,
  //     "-C",
  //     local.postgres_storage_migrations_data_source_path,
  //     "."
  //   ]
  // }

  // after_hook "remove_migration_tar_files" {
  //   commands     = ["destroy"]
  //   run_on_error = true
  //   execute = [
  //     "rm",
  //     "-rf",
  //     local.postgres_storage_migrations_sql_tar_path,
  //     local.postgres_storage_migrations_data_tar_path
  //   ]
  // }
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
