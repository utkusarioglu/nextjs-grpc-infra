terraform {
  source = "${get_repo_root()}/modules//${basename(get_terragrunt_dir())}"
}

locals {
  config_templates = {
    vars = [
      "helm",
      "deployment-config",
      "platform",
      "project",
      "ingress-sg",
      "url"
    ],
    locals = [
      "ingress"
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

generate "locals_target" {
  path      = "locals-target.generated.tf"
  if_exists = "overwrite"
  contents = join("\n", ([
    for i, identifier in local.config_templates.locals :
    templatefile("${get_repo_root()}/assets/templates/locals/${identifier}.tftpl.hcl", {})
  ]))
}
