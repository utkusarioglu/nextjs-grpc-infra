dependencies {
  paths = [
    "../vault-config",
    "../cert-manager"
  ]
}

dependency "vault_config" {
  config_path = "../vault-config"
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_repo_root()}/modules//tier-1"
}

inputs = {
  vault_kubernetes_mount_path = dependency.vault_config.outputs.vault_kubernetes_mount_path
}

generate "vars_helm" {
  path      = "vars.helm.generated.tf"
  if_exists = "overwrite"
  contents  = templatefile("${get_repo_root()}/assets/templates/vars.helm.tftpl.hcl", {})
}
