dependencies {
  paths = [
    "../tier-1"
  ]
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_repo_root()}/modules//tier-2"
}

inputs = {
  ingress_sg = "<DOES_NOT_APPLY_IN_LOCAL>"
}

generate "vars_helm" {
  path      = "vars.helm.generated.tf"
  if_exists = "overwrite"
  contents  = templatefile("${get_repo_root()}/assets/templates/vars.helm.tftpl.hcl", {})
}
