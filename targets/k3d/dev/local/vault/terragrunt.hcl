include "repo" {
  path = "${get_repo_root()}/terragrunt.repo.hcl"
}

include "region" {
  path = "../terragrunt.region.hcl"
}

include "module" {
  path = "${get_repo_root()}/modules//${basename(get_terragrunt_dir())}/terragrunt.hcl"
}

dependencies {
  paths = [
    "../ingress-nginx"
  ]
}

terraform {
  after_hook "vault_unsealer" {
    commands = ["apply"]
    execute = [
      "scripts/vault-unseal.sh",
    ]
  }
}

inputs = {
  platform                       = "k3d"
  platform_specific_vault_config = ""

  // created by after_hook of nginx-ingress
  cluster_ca_crt_b64 = file("/tmp/nextjs-grpc/ca.b64.crt")
}

locals {
  config_templates = {
    vars = [
      "helm",
      "deployment-config",
      "tls-ca-cert",
      "tls-intermediate-cert",
      "tls-intermediate-key",
      "url",
      "paths",
    ]
  }
}

generate "vars_target" {
  path      = "vars-target.generated.tf"
  if_exists = "overwrite"
  contents = join("\n", ([
    for i, identifier in local.config_templates.vars :
    templatefile("${get_repo_root()}/assets/templates/vars.${identifier}.tftpl.hcl", {})
  ]))
}
