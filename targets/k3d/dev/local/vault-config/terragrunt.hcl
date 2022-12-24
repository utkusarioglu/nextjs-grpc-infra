include "repo" {
  path = "${get_repo_root()}/terragrunt.repo.hcl"
}

include "region" {
  path = "../terragrunt.region.hcl"
}

include "module" {
  path = "${get_repo_root()}/modules//${basename(get_terragrunt_dir())}/terragrunt.hcl"
}

dependencies {
  paths = [
    "../vault"
  ]
}

locals {
  config_templates = {
    vars = [
      "deployment-config",
      "paths"
    ],
    providers = [
      "vault"
    ]
  }
}

generate "vars_target" {
  path      = "vars-target.generated.tf"
  if_exists = "overwrite"
  contents = join("\n", ([
    for i, identifier in local.config_templates.vars :
    templatefile("${get_repo_root()}/assets/templates/vars.${identifier}.tftpl.hcl", {})
  ]))
}

generate "providers_target" {
  path      = "providers-target.generated.tf"
  if_exists = "overwrite"
  contents = join("\n", ([
    for i, identifier in local.config_templates.providers :
    templatefile("${get_repo_root()}/assets/templates/providers/${identifier}.tftpl.hcl", {})
  ]))
}
