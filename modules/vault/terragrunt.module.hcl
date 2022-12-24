terraform {
  source = "${get_repo_root()}/modules//${basename(get_terragrunt_dir())}"

  extra_arguments "vault_vars" {
    commands = [
      "apply",
      "plan",
      "destroy",
    ]
    required_var_files = [
      "${get_repo_root()}/vars/common.tfvars",
      "${get_repo_root()}/vars/${basename(get_terragrunt_dir())}.common.tfvars"
    ]
  }
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
    templatefile("${get_repo_root()}/assets/templates/vars/${identifier}.tftpl.hcl", {})
  ]))
}
