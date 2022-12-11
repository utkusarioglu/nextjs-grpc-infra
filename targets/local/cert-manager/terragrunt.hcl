dependencies {
  paths = [
    "../vault-config"
  ]
}

// dependency "vault_config" {
//   config_path = "../vault-config"
// }

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_repo_root()}/modules//cert-manager"
}

generate "vars_helm" {
  path      = "vars.helm.generated.tf"
  if_exists = "overwrite"
  contents  = templatefile("${get_repo_root()}/assets/templates/vars.helm.tftpl.hcl", {})
}
