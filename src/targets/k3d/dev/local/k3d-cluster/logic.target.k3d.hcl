locals {
  lineage = read_terragrunt_config(join("/", [
    path_relative_to_include(),
    "lineage.hcl"
  ]))
  parents          = local.lineage.locals.parents
  template_types   = local.lineage.locals.template_types
  module_hierarchy = local.lineage.locals.module_hierarchy
  module_role      = local.lineage.locals.module_role

  config_templates = []

  aggregated_config_templates = {
    for template_type in local.template_types :
    template_type => flatten([[
      for parent in local.module_hierarchy :
      try(local.parents[parent].locals.config_templates[template_type], [])
    ], try(local.config_templates[template_type], [])])
  }
}

terraform {
  before_hook "echo parents_new" {
    commands = ["validate"]
    execute = [
      "sh",
      "-c",
      join(" ", [
        "echo",
        "parents_new: ",
        jsonencode(local.lineage.locals.debug_output)
      ])
    ]
  }
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
