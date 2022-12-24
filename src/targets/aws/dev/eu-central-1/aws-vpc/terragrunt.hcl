include "root" {
  path = find_in_parent_folders()
}

include "module" {
  path = "${get_repo_root()}/src/modules//${basename(get_terragrunt_dir())}/terragrunt.hcl"
}
