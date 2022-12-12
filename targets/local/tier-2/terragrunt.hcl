dependencies {
  paths = [
    "../tier-1"
  ]
}

include "root" {
  path = find_in_parent_folders()
}

include "config" {
  path = "${get_repo_root()}/configs//${basename(get_terragrunt_dir())}/config.hcl"
}

inputs = {
  ingress_sg = "<DOES_NOT_APPLY_IN_LOCAL>"
}
