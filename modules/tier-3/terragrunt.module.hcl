terraform {
  source = "${get_repo_root()}/modules//${basename(get_terragrunt_dir())}"
}

locals {
  config_templates = {
    vars = [
      {
        name = "helm"
        args = {}
      },
      {
        name = "deployment-config",
        args = {}
      },
      {
        name = "ingress-sg"
        args = {}
      },
      {
        name = "platform"
        args = {}
      },
      {
        name = "project"
        args = {}
      },
      {
        name = "url"
        args = {}
      },
    ]
    locals = [
      {
        name = "ingress"
        args = {}
      }
    ]
  }
}

// generate "vars_target" {
//   path      = "vars-target.generated.tf"
//   if_exists = "overwrite"
//   contents = join("\n", ([
//     for i, identifier in local.config_templates.vars :
//     templatefile("${get_repo_root()}/assets/templates/vars/${identifier}.tftpl.hcl", {})
//   ]))
// }

// generate "locals_target" {
//   path      = "locals-target.generated.tf"
//   if_exists = "overwrite"
//   contents = join("\n", ([
//     for i, identifier in local.config_templates.locals :
//     templatefile("${get_repo_root()}/assets/templates/locals/${identifier}.tftpl.hcl", {})
//   ]))
// }

generate "templated_config" {
  path      = "templated-config.tf"
  if_exists = "overwrite"
  contents = join("\n", ([
    for key, items in local.config_templates :
    (join("\n", [
      for j, template in items :
      templatefile(
        "${get_repo_root()}/assets/templates/${key}/${template.name}.tftpl.hcl",
        template.args
      )
    ]))
  ]))
}
