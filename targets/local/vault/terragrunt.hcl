dependencies {
  paths = [
    "../ingress"
  ]
}

include {
  path = find_in_parent_folders()
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

include "root" {
  path = find_in_parent_folders()
}
