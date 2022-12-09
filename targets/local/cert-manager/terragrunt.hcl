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
  source = "${get_repo_root()}/modules/cert-manager"
}

// inputs = {
//   vault_kubernetes_mount_path = dependency.vault_config.outputs.vault_kubernetes_mount_path
// }
