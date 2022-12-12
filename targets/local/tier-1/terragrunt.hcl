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

include "config" {
  path = "${get_repo_root()}/configs//${basename(get_terragrunt_dir())}/config.hcl"
}

inputs = {
  vault_kubernetes_mount_path = dependency.vault_config.outputs.vault_kubernetes_mount_path
}
