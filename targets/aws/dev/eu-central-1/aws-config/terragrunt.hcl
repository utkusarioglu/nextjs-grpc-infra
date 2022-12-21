dependencies {
  paths = [
    "../aws-eks"
  ]
}

dependency "aws_base" {
  config_path = "../aws-eks"
}

include "root" {
  path = find_in_parent_folders()
}

include "config" {
  path = "${get_repo_root()}/modules//${basename(get_terragrunt_dir())}/terragrunt.hcl"
}

inputs = {
  cluster_name = dependency.aws_base.outputs.cluster_id
}
