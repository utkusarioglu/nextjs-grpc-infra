dependencies {
  paths = [
    "../tier-2"
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

inputs = {
  ingress_sg = dependency.aws_base.outputs.aws_alb_security_group_id
}
