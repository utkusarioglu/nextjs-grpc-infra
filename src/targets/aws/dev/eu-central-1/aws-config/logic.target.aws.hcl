locals {
  parents_target    = read_terragrunt_config("./parents.target.hcl").locals
  parents           = local.parents_target.parents
  template_types    = local.parents_target.template_types
  parent_precedence = local.parents_target.template_types


  region            = local.parents.region.inputs.region
  aws_profile       = local.parents.region.inputs.aws_profile
  region_identifier = local.parents.region.inputs.region_identifier
  cluster_name      = local.parents.region.inputs.cluster_name

  target_identifier = concat(local.region_identifier, [
    "${basename(get_terragrunt_dir())}"
  ])
  target_name = join("-", local.target_identifier)
  s3_key      = join("/", concat(local.target_identifier, ["terraform.tfstate"]))

  remote_state_config = {
    bucket         = local.target_name
    key            = local.s3_key
    region         = local.region
    encrypt        = true
    dynamodb_table = local.target_name
    profile        = local.aws_profile
  }

  config_templates = {
    backends = [
      {
        name = "aws"
        args = local.remote_state_config
      }
    ]
    providers = [
      {
        name = "aws-helm-kubernetes"
        args = {
          cluster_name = local.cluster_name
        }
      }
    ]
  }

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
