dependencies {
  paths = [
    "../tier-1"
  ]
}

include "root" {
  path = find_in_parent_folders()
}

include "vars" {
  path = "./vars.hcl"
}

terraform {
  source = "${get_repo_root()}/modules//tier-2"
}

inputs = {
  ingress_sg = "<DOES_NOT_APPLY_IN_LOCAL>"
}
