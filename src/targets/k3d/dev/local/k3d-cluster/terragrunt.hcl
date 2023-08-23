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

include "logic" {
  path = "./terragrunt.logic.hcl"
}

locals {
  parents = read_terragrunt_config("./terragrunt.logic.hcl").locals.parents

  cluster_name = local.parents.region.locals.cluster_name

  k3d_config_path        = "${get_repo_root()}/src/configs/k3d.config.yml"
  destroy_cluster_action = "delete" // or stop
}

terraform {
  before_hook "check_requirements" {
    commands = [
      "apply",
      "plan"
    ]
    execute = [
      "scripts/check-requirements.sh",
      "${get_repo_root()}"
    ]
  }

  before_hook "start_k3d_cluster" {
    commands = [
      "apply",
      "plan"
    ]
    execute = [
      "scripts/start-k3d-cluster.sh",
      local.cluster_name,
      local.k3d_config_path
    ]
  }

  // Needed by Vault 
  after_hook "retrieve_ca_crt_file" {
    commands = ["plan", "apply"]
    execute = [
      "scripts/kubectl-get-cluster-ca.sh",
      "${get_repo_root()}/artifacts/cluster-ca/cluster-ca.crt"
    ]
  }

  after_hook "stop_k3d_cluster" {
    commands = [
      "plan",
      "destroy"
    ]
    working_dir = "${get_repo_root()}/src/configs"
    execute = [
      "k3d",
      "cluster",
      local.destroy_cluster_action,
      local.cluster_name
    ]
  }
}
