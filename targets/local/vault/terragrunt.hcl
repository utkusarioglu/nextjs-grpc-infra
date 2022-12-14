dependencies {
  paths = [
    "../ingress-nginx"
  ]
}

include "root" {
  path = find_in_parent_folders()
}

include "config" {
  path = "${get_repo_root()}/configs//${basename(get_terragrunt_dir())}/config.hcl"
}
