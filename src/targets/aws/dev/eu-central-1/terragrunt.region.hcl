inputs = {
  deployment_mode   = "all"
  helm_timeout_unit = 600
  helm_atomic       = true

  region            = local.region
  cluster_name      = local.cluster_name
  aws_profile       = local.aws_profile
  region_identifier = local.region_identifier
}

locals {
  region       = "eu-central-1"
  region_short = "euc1"
  aws_profile  = "utkusarioglu"

  parents_region = read_terragrunt_config(join("/", [
    path_relative_from_include(),
    "lineage.hcl"
  ]))
  parents          = local.parents_region.locals.parents
  module_hierarchy = local.parents_region.locals.module_hierarchy

  project_name       = local.parents.repo.inputs.project_name
  project_name_short = local.parents.repo.inputs.project_name_short
  platform           = local.parents.platform.inputs.platform
  environment        = local.parents.environment.inputs.environment

  region_identifier = [
    local.project_name_short,
    local.platform,
    local.environment,
    local.region_short
  ]
  cluster_name = join("-", local.region_identifier)

  aws_provider_args = {
    cluster_region     = local.region
    aws_profile        = local.aws_profile
    platform           = local.platform
    environment        = local.environment
    region             = local.region
    region_short       = local.region_short
    metarepo_name      = local.project_name // this may need to be changed
    project_name       = local.project_name
    project_name_short = local.project_name_short
    aws_profile        = local.aws_profile
  }

  config_templates = {
    providers = [
      {
        name = "aws"
        args = local.aws_provider_args
      },
      {
        name = "aws-dns",
        args = local.aws_provider_args
      }
    ]
  }

  // target_parts       = split("/", trimprefix(get_path_from_repo_root(), "src/targets/"))
  // parent_precedence2 = ["repo", "platform", "environment", "region", "target", "module"]
  // module_parents     = slice(local.parent_precedence2, 1, length(local.target_parts) + 1)
  // zipped = zipmap(
  //   local.module_parents,
  //   local.target_parts
  // )
}

terraform {
  //   before_hook "echo" {
  //     commands = ["validate"]
  //     execute  = ["sh", "-c", "echo path from repo root: ${jsonencode(local.zipped)}"]
  //   }
  before_hook "echo2" {
    commands = ["validate"]
    execute  = ["sh", "-c", "echo module_avoid: ${jsonencode(local.parents_region.locals.module_descendants)}"]
  }
}
