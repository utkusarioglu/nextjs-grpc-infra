include "repo" {
  path = "${get_repo_root()}/terragrunt.repo.hcl"
}

include "region" {
  path = "../terragrunt.region.hcl"
}

include "module" {
  path = "${get_repo_root()}/modules//${basename(get_terragrunt_dir())}/terragrunt.module.hcl"
}

dependencies {
  paths = [
    "../vault-config"
  ]
}
