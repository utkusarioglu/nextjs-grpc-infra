terraform {
  source = "${get_repo_root()}/modules//${basename(get_terragrunt_dir())}"
}

locals {
  config_templates = {
    vars = [
      {
        name = "deployment-config"
      },
      {
        name = "paths"
      }
    ],
    providers = [
      {
        name = "vault"
      }
    ]
  }
}

generate "generated_config_module" {
  path      = "generated-config.module.tf"
  if_exists = "overwrite"
  contents = join("\n", ([
    for key, items in local.config_templates :
    (join("\n", [
      for j, template in items :
      templatefile(
        "${get_repo_root()}/assets/templates/${key}/${template.name}.tftpl.hcl",
        try(template.args, {})
      )
    ]))
  ]))
}
