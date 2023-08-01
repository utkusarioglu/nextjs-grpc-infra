inputs = {
  // deployment_mode = "all"
  // deployment_mode = "no_observability"
  // deployment_mode   = "grafana"
  // deployment_mode   = "web_server"
  deployment_mode   = get_env("K3D_DEV_LOCAL_DEPLOYMENT_MODE", "all")
  helm_timeout_unit = 180
  helm_atomic       = true
  api_run_mode      = "production"
  ms_run_mode       = "production"

  region = local.region
}

locals {
  region = "local"

  parents = {
    for parent in ["repo", "environment", "platform"] :
    parent => read_terragrunt_config(
      find_in_parent_folders("terragrunt.${parent}.hcl")
    )
  }

  project_name = local.parents.repo.inputs.project_name
  platform     = local.parents.platform.inputs.platform
  environment  = local.parents.environment.inputs.environment

  region_identifier = [
    local.project_name,
    local.platform,
    local.environment,
    local.region
  ]
  cluster_name = join("-", local.region_identifier)

  config_templates = {
    providers = [
      {
        name = "k3d-helm"
        args = {
          cluster_name = local.cluster_name
        }
      },
      {
        name = "k3d-kubernetes"
        args = {
          cluster_name = local.cluster_name
        }
      },
    ]
  }
}

generate "generated_config_region" {
  path      = "generated-config.region.tf"
  if_exists = "overwrite"
  contents = join("\n", ([
    for key, items in local.config_templates :
    (join("\n", [
      for j, template in items :
      templatefile(
        "${get_repo_root()}/src/templates/${key}/${template.name}.tftpl.hcl",
        try(template.args, {})
      )
    ]))
  ]))
}
