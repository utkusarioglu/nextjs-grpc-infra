include "repo" {
  path = "${get_repo_root()}/terragrunt.repo.hcl"
}

include "region" {
  path = "../terragrunt.region.hcl"
}

include "module" {
  path = "${get_repo_root()}/modules//${basename(get_terragrunt_dir())}/terragrunt.hcl"
}

dependencies {
  paths = [
    "../tier-2"
  ]
}

inputs = {
  ingress_sg = "DOES_NOT_APPLY_IN_LOCAL"
}
