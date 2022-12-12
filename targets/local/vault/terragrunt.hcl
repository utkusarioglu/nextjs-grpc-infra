dependencies {
  paths = [
    "../ingress"
  ]
}

include "root" {
  path = find_in_parent_folders()
}

include "vars" {
  path = "./vars.hcl"
}

terraform {
  source = "${get_repo_root()}/modules//vault"

  extra_arguments "vault_vars" {
    commands = [
      "apply",
      "plan",
      "destroy",
    ]
    required_var_files = [
      "${get_repo_root()}/vars/vault.common.tfvars"
    ]
  }
}
