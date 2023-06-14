locals {
  private_templates_path = "${var.configs_abspath}/postgres-storage/vault-templates"

  private_postgres_storage_namespace    = "ms"
  private_postgres_storage_service_name = "postgres-storage"
  private_postgres_storage_service_port = "5432"
  postgres_storage = {
    connection_url = join("", [
      "postgresql://{{username}}:{{password}}",
      "@",
      local.private_postgres_storage_service_name,
      ".",
      local.private_postgres_storage_namespace,
      ":",
      local.private_postgres_storage_service_port
    ])

    vault_templates = {
      common = {
        root_rotation_statements = [
          for line in split("\n", file(join("/", [
            local.private_templates_path,
            "common",
            "root-rotation-statements.sql"
          ]))) : line if line != ""
        ]

        creation_statements = split("\n", file(join("/", [
          local.private_templates_path,
          "common",
          "creation-statements.sql"
        ])))

        revocation_statements = split("\n", file(join("/", [
          local.private_templates_path,
          "common",
          "revocation-statements.sql"
        ])))
      }

      inflation = {
        creation_statements = [
          for line in split("\n", file(join("/", [
            local.private_templates_path,
            "inflation",
            "creation-statements.sql"
          ]))) : line if line != ""
        ]

        revocation_statements = [
          for line in split("\n", file(join("/", [
            local.private_templates_path,
            "inflation",
            "revocation-statements.sql"
          ]))) : line if line != ""
        ]
      }

      ai_education_public = {
        creation_statements = [
          for line in split("\n", file(join("/", [
            local.private_templates_path,
            "ai-education/public",
            "creation-statements.sql"
          ]))) : line if line != ""
        ]
        revocation_statements = [
          for line in split("\n", file(join("/", [
            local.private_templates_path,
            "ai-education/public",
            "revocation-statements.sql"
          ]))) : line if line != ""
        ]
      }

      ai_education_restricted = {
        creation_statements = [
          for line in split("\n", file(join("/", [
            local.private_templates_path,
            "ai-education/restricted",
            "creation-statements.sql"
          ]))) : line if line != ""
        ]
        revocation_statements = [
          for line in split("\n", file(join("/", [
            local.private_templates_path,
            "ai-education/restricted",
            "revocation-statements.sql"
          ]))) : line if line != ""
        ]
      }
    }
  }
}
