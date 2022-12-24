include "repo" {
  path = "${get_repo_root()}/terragrunt.repo.hcl"
}

include "platform" {
  path = "../../../terragrunt.platform.hcl"
}

include "region" {
  path = "../terragrunt.region.hcl"
}

include "module" {
  path = "${get_repo_root()}/src/modules//${basename(get_terragrunt_dir())}/terragrunt.module.hcl"
}

terraform {
  extra_arguments "ingres_nginx_vars" {
    commands = [
      "apply",
      "plan",
      "destroy",
    ]
    required_var_files = [
      "${get_repo_root()}/vars/${basename(get_terragrunt_dir())}.local.tfvars"
    ]
  }

  before_hook "start_k3d_cluster" {
    commands = [
      "apply",
      "plan"
    ]
    working_dir = "/utkusarioglu-com/projects/nextjs-grpc/infra/src/configs"
    execute     = ["k3d", "cluster", "start", "nextjs-grpc-infra-target-local"]
  }

  // Needed by Vault 
  after_hook "retrieve_ca_crt_file" {
    commands = ["plan", "apply"]
    execute  = ["scripts/kubectl-get-ca.sh", "${get_repo_root()}/artifacts/ca"]
  }

  after_hook "stop_k3d_cluster" {
    commands = [
      "plan",
      "destroy"
    ]
    working_dir = "/utkusarioglu-com/projects/nextjs-grpc/infra/src/configs"
    execute     = ["k3d", "cluster", "stop", "nextjs-grpc-infra-target-local"]
  }
}
