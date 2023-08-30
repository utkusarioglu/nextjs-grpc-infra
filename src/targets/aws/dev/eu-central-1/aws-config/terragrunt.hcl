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

include "generate" {
  path = "./generate.target.aws.helper.hcl"
}

include "hooks" {
  path = "./hooks.target.aws.helper.hcl"
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
  prep                = read_terragrunt_config("./remote-state.target.aws.helper.hcl")
  remote_state_config = local.prep.locals.remote_state_config
}

remote_state {
  backend = "s3"
  config  = local.remote_state_config
}
