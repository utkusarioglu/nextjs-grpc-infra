terraform {
  source = "${get_repo_root()}/modules//${basename(get_terragrunt_dir())}"

  extra_arguments "vault_vars" {
    commands = [
      "apply",
      "plan",
      "destroy",
    ]
    required_var_files = [
      "${get_repo_root()}/vars/common.tfvars",
      "${get_repo_root()}/vars/${basename(get_terragrunt_dir())}.common.tfvars"
    ]
  }
}

locals {
  config_templates = {
    vars = [
      {
        name = "helm"
      },
      {
        name = "deployment-config"
      },
      {
        name = "tls-ca-cert"
      },
      {
        name = "tls-intermediate-cert"
      },
      {
        name = "tls-intermediate-key"
      },
      {
        name = "url"
      },
      {
        name = "paths"
      },
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
