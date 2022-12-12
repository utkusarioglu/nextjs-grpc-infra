dependencies {
  paths = [
    "../cert-manager",
    "../vault-config"
  ]
}

dependency "vault_config" {
  config_path = "../vault-config"
}

include "root" {
  path = find_in_parent_folders()
}

include "vars" {
  path = "./vars.hcl"
}

terraform {
  source = "${get_repo_root()}/modules//tier-1"
}

inputs = {
  vault_kubernetes_mount_path = dependency.vault_config.outputs.vault_kubernetes_mount_path
}
