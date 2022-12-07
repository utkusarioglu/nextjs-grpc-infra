dependencies {
  paths = [
    "../ingress"
  ]
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_repo_root()}/modules/vault"
}

include "root" {
  path = find_in_parent_folders()
}
