dependencies {
  paths = [
    "../ingress-nginx"
  ]
}

terraform {
  after_hook "vault_unsealer" {
    commands = ["apply"]
    execute  = ["scripts/vault-unseal.sh"]
  }
}

include "root" {
  path = find_in_parent_folders()
}

include "config" {
  path = "${get_repo_root()}/configs//${basename(get_terragrunt_dir())}/config.hcl"
}

inputs = {
  platform_specific_vault_config = ""
}
