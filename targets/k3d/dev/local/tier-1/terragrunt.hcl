include "repo" {
  path = "${get_repo_root()}/terragrunt.repo.hcl"
}

include "platform" {
  path = "../../../terragrunt.platform.hcl"
}

include "region" {
  path = "../terragrunt.region.hcl"
}

include "module" {
  path = "${get_repo_root()}/modules//${basename(get_terragrunt_dir())}/terragrunt.module.hcl"
}

dependencies {
  paths = [
    "../cert-manager",
    "../vault-config"
  ]
}

dependency "vault_config" {
  config_path = "../vault-config"
}

inputs = {
  vault_kubernetes_mount_path = dependency.vault_config.outputs.vault_kubernetes_mount_path
}
