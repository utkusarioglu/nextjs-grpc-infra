dependencies {
  paths = [
    "../vault"
  ]
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_repo_root()}/modules/vault-config"

  // extra_arguments "vault_vars" {
  //   commands = [
  //     "apply",
  //     "plan",
  //     "destroy",
  //   ]
  //   required_var_files = [
  //     "${get_repo_root()}/vars/vault.common.tfvars"
  //   ]
  // }
}

generate "providers" {
  path      = "provider.vault.generated.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "vault" { }
  EOF
}
