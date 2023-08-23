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

dependencies {
  paths = [
    "../aws-eks"
  ]
}

dependency "aws_eks" {
  config_path = "../aws-eks"

  mock_outputs = {
    cluster_id = "mock"
  }

  mock_outputs_allowed_terraform_commands = ["validate"]
}

inputs = {
  cluster_name = dependency.aws_eks.outputs.cluster_id
}

locals {
  logic = read_terragrunt_config("./terragrunt.logic.hcl").locals
}

remote_state {
  backend = "s3"
  config  = local.logic.remote_state_config
}
