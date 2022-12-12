dependencies {
  paths = [
    "../vault-config"
  ]
}

include "root" {
  path = find_in_parent_folders()
}

include "vars" {
  path = "./vars.hcl"
}

terraform {
  source = "${get_repo_root()}/modules//cert-manager"
}
