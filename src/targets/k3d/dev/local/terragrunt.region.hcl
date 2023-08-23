inputs = {
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
    required_providers = [
      {
        name = "helm"
        args = {
          cluster_name = local.cluster_name
        }
      },
      {
        name = "kubernetes"
        args = {
          cluster_name = local.cluster_name
        }
      },
    ]
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
