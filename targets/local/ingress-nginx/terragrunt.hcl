include {
  path = find_in_parent_folders()
}

include "vars" {
  path = "./vars.hcl"
}

terraform {
  source = "${get_repo_root()}/modules//${basename(get_terragrunt_dir())}"

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
    working_dir = "/utkusarioglu-com/projects/nextjs-grpc/infra/assets"
    execute     = ["k3d", "cluster", "start", "nextjs-grpc-infra-target-local"]
  }

  after_hook "stop_k3d_cluster" {
    commands = [
      "plan",
      "destroy"
    ]
    working_dir = "/utkusarioglu-com/projects/nextjs-grpc/infra/assets"
    execute     = ["k3d", "cluster", "stop", "nextjs-grpc-infra-target-local"]
  }
}
