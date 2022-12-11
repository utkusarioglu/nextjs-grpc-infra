dependencies {
  paths = [
    "../vault"
  ]
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_repo_root()}/modules//vault-config"
}

generate "providers" {
  path      = "provider.vault.generated.tf"
  if_exists = "overwrite"
  contents  = templatefile("${get_repo_root()}/assets/templates/provider.vault.tftpl.hcl", {})
}
