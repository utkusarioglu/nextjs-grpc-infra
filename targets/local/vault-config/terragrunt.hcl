dependencies {
  paths = [
    "../vault"
  ]
}

include "root" {
  path = find_in_parent_folders()
}

include "vars" {
  path = "./vars.hcl"
}

terraform {
  source = "${get_repo_root()}/modules//vault-config"
}
