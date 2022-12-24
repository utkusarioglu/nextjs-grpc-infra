include "repo" {
  path = "${get_repo_root()}/terragrunt.repo.hcl"
}

include "region" {
  path = "../terragrunt.region.hcl"
}

include "module" {
  path = "${local.module_path}/terragrunt.module.hcl"
}

terraform {
  // path = "${local.module_path}/terragrunt.module.hcl"

  extra_arguments "ingres_nginx_vars" {
    commands = [
      "apply",
      "plan",
      "destroy",
    ]
    required_var_files = [
      "${get_repo_root()}/vars/${basename(get_terragrunt_dir())}.local.tfvars"
    ]
  }

  before_hook "start_k3d_cluster" {
    commands = [
      "apply",
      "plan"
    ]
    working_dir = "/utkusarioglu-com/projects/nextjs-grpc/infra/assets"
    execute     = ["k3d", "cluster", "start", "nextjs-grpc-infra-target-local"]
  }

  // Needed by Vault 
  after_hook "ca_crt" {
    commands = ["plan", "apply"]
    execute = [
      "scripts/kubectl-get-ca.sh"
    ]
  }

  after_hook "stop_k3d_cluster" {
    commands = [
      "plan",
      "destroy"
    ]
    working_dir = "/utkusarioglu-com/projects/nextjs-grpc/infra/assets"
    execute     = ["k3d", "cluster", "stop", "nextjs-grpc-infra-target-local"]
  }
}

locals {
  module_path = "${get_repo_root()}/modules//${basename(get_terragrunt_dir())}"
  config_templates = {
    vars = [
      "helm",
      "deployment-config",
      "tls-intermediate-cert",
      "tls-intermediate-key",
      "url"
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
