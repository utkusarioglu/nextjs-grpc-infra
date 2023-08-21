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

dependencies {
  paths = [
    "../k3d-cluster",
  ]
}

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
}

terraform {
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
