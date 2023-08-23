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

  parents = {
    for parent in ["repo", "environment", "platform"] :
    parent => read_terragrunt_config(
      find_in_parent_folders("terragrunt.${parent}.hcl")
    )
  }

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
}
