locals {
  lineage_helper_hcl = read_terragrunt_config("./lineage.helper.hcl")
  template_types     = local.lineage_helper_hcl.locals.template_types
  module_hierarchy   = local.lineage_helper_hcl.locals.module_hierarchy
  parents            = local.lineage_helper_hcl.locals.parents

  config_templates_target_aws_hcl = read_terragrunt_config("./config-templates.target.aws.hcl")
  config_templates                = local.config_templates_target_aws_hcl.locals.config_templates

  aggregated_config_templates = {
    for template_type in local.template_types :
    template_type => flatten([[
      for parent in local.module_hierarchy :
      try(local.parents[parent].locals.config_templates[template_type], [])
    ], try(local.config_templates[template_type], [])])
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
