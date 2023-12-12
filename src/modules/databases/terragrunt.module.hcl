terraform {
  source = join("/", [
    get_repo_root(),
    "src/modules/",
    basename(get_terragrunt_dir())
  ])

  extra_arguments "required_var_files" {
    commands = [
      "apply",
      "plan",
      "destroy",
    ]
    required_var_files = [
      for file in local.required_var_files :
      "${get_repo_root()}/vars/${file}.tfvars"
    ]
  }
}

locals {
  required_var_files = [
    "postgres-storage"
  ]

  config_templates = {
    vars = [
      {
        name = "helm",
      },
      {
        name = "deployment-config",
      },
      // {
      //   name = "configs-abspath",
      // },
      {
        name = "vault-secrets-mount-path",
      },
      {
        name = "platform"
      }
    ]

    providers = [
      {
        name = "vault"
      }
    ]

    required_providers = [
      {
        name = "vault"
      }
    ]

    data = [
      {
        name = "postgres-storage-postgres-role-credentials",
      },
      {
        name = "postgres-storage-vault-manager-roles-credentials",
      }
    ]

    locals = [
      {
        name = "postgres-storage-postgres-master-credentials",
      },
      {
        name = "postgres-storage-vault-manager-roles-credentials",
      }
    ]
  }
}

// generate "generated_config_module" {
//   path      = "generated-config.module.tf"
//   if_exists = "overwrite"
//   contents = join("\n", ([
//     for key, items in local.config_templates :
//     (join("\n", [
//       for j, template in items :
//       templatefile(
//         "${get_repo_root()}/src/templates/${key}/${template.name}.tftpl.hcl",
//         try(template.args, {})
//       )
//     ]))
//   ]))
// }
