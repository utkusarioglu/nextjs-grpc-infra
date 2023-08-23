locals {
  parent_precedence = ["repo", "platform", "environment", "region"]
  template_types = [
    "required_providers",
    "providers",
    "backends",
    "data",
    "locals",
    "vars"
  ]

  parents = merge({
    for parent in local.parent_precedence :
    parent => read_terragrunt_config(
      find_in_parent_folders("terragrunt.${parent}.hcl")
    )
    }, {
    module = read_terragrunt_config(join("/", [
      get_repo_root(),
      "src/modules/",
      basename(get_terragrunt_dir()),
      "terragrunt.module.hcl"
      ])
    )
  })

  aggregated_config_templates = {
    for template_type in local.template_types :
    template_type => flatten([
      for parent in flatten([local.parent_precedence, "module"]) :
      try(local.parents[parent].locals.config_templates[template_type], [])
    ])
  }

  // artifacts_abspath    = local.parents.repo.inputs.artifacts_abspath
  // project_root_abspath = local.parents.repo.inputs.project_root_abspath

  // postgres_storage_migrations_sources_root_path = "${local.project_root_abspath}/notebooks/src/migrations"
  // postgres_storage_migrations_sql_source_path   = "${local.postgres_storage_migrations_sources_root_path}/sql"
  // postgres_storage_migrations_data_source_path  = "${local.postgres_storage_migrations_sources_root_path}/data"

  // postgres_storage_migrations_source_paths = [
  //   local.postgres_storage_migrations_sql_source_path,
  //   local.postgres_storage_migrations_data_source_path,
  // ]
  // postgres_storage_migrations_file_list = flatten([
  //   for path in local.postgres_storage_migrations_source_paths :
  //   tolist([for filename in fileset(path, "**") :
  //     "${path}/${filename}"]
  //   )
  // ])
  // postgres_storage_migrations_hash = substr(
  //   sha256(
  //     join("", [
  //       for file in local.postgres_storage_migrations_file_list :
  //       filesha256(file)
  //     ])
  //   ),
  //   0, 10
  // )

  // postgres_storage_migration_artifacts_abspath = join("/", [
  //   local.artifacts_abspath,
  //   "postgres-storage"
  // ])

  // postgres_storage_migrations_sql_tar_path = join("", [
  //   local.postgres_storage_migration_artifacts_abspath,
  //   "/",
  //   "migrations-sql",
  //   "-",
  //   local.postgres_storage_migrations_hash,
  //   ".tar"
  // ])
  // postgres_storage_migrations_data_tar_path = join("", [
  //   local.postgres_storage_migration_artifacts_abspath,
  //   "/",
  //   "migrations-data",
  //   "-",
  //   local.postgres_storage_migrations_hash,
  //   ".tar"
  // ])
}

// inputs = {
//   postgres_storage_migrations_sql_tar_path  = local.postgres_storage_migrations_sql_tar_path
//   postgres_storage_migrations_data_tar_path = local.postgres_storage_migrations_data_tar_path
//   postgres_storage_migrations_hash          = local.postgres_storage_migrations_hash
//   vault_secrets_mount_path                  = dependency.vault_config.outputs.vault_secrets_mount_path
// }

terraform {
  // before_hook "create_migrations_artifacts" {
  //   commands = ["apply"]
  //   execute = [
  //     "scripts/create-migration-tar-files.sh",
  //     local.postgres_storage_migration_artifacts_abspath,
  //     local.postgres_storage_migrations_sql_tar_path,
  //     local.postgres_storage_migrations_sql_source_path,
  //     local.postgres_storage_migrations_data_tar_path,
  //     local.postgres_storage_migrations_data_source_path,
  //   ]
  // }

  // after_hook "remove_migration_tar_files" {
  //   commands     = ["destroy"]
  //   run_on_error = true
  //   execute = [
  //     "rm",
  //     "-rf",
  //     local.postgres_storage_migration_artifacts_abspath
  //   ]
  // }

  after_hook "validate_tflint" {
    commands = ["validate"]
    execute  = ["sh", "-c", "tflint --config=.tflint.hcl -f default"]
  }
}

generate "generated_config_target" {
  path      = "aggregated_config_templates.tf"
  if_exists = "overwrite"
  contents = join("\n\n", ([
    for key, items in local.aggregated_config_templates :
    (
      templatefile(
        "${get_repo_root()}/src/templates/wrappers/${key}.tftpl.hcl", {
          contents = join("\n", [
            for j, template in items :
            templatefile(
              "${get_repo_root()}/src/templates/${key}/${template.name}.tftpl.hcl",
              try(template.args, {})
            )
          ])
        }
      )
    )
  ]))
}
