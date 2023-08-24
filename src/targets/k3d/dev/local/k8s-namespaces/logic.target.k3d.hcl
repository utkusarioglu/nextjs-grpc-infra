locals {
  parents_target = read_terragrunt_config(join("/", [
    path_relative_to_include(),
    "parents.target.hcl"
  ]))
  parents           = local.parents_target.locals.parents
  template_types    = local.parents_target.locals.template_types
  parent_precedence = local.parents_target.locals.parent_precedence

  config_templates = []

  aggregated_config_templates = {
    for template_type in local.template_types :
    template_type => flatten([[
      for parent in flatten([local.parent_precedence, "module"]) :
      try(local.parents[parent].locals.config_templates[template_type], [])
    ], try(local.config_templates[template_type], [])])
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
        join("/", [
          get_repo_root(),
          "src/templates/wrappers",
          "${key}.tftpl.hcl"
        ]),
        {
          contents = join("\n", [
            for j, template in items :
            templatefile(
              join("/", [
                get_repo_root(),
                "src/templates",
                key,
                "${template.name}.tftpl.hcl"
              ]),
              try(template.args, {})
            )
          ])
        }
      )
    )
  ]))
}
