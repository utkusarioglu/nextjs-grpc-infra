dependencies {
  paths = [
    "../aws-base"
  ]
}

dependency "aws_base" {
  config_path = "../aws-base"
}

include "root" {
  path = find_in_parent_folders()
}

include "config" {
  path = "${get_repo_root()}/configs//${basename(get_terragrunt_dir())}/config.hcl"
}

inputs {
  cluster_name = dependency.aws_base.outputs.cluster_id
}
