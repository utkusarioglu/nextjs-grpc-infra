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
    "../ingress-nginx"
  ]
}

inputs = {
  platform                       = "k3d"
  platform_specific_vault_config = ""

  // created by after_hook of nginx-ingress
  cluster_ca_crt_b64 = file("${get_repo_root()}/artifacts/ca/ca.b64.crt")
}

terraform {
  after_hook "vault_unsealer" {
    commands = ["apply"]
    execute = [
      "scripts/vault-unseal.sh",
      "${get_repo_root()}/artifacts/vault"
    ]
  }
}
