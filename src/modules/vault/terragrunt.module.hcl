terraform {
  source = join("/", [
    get_repo_root(),
    "src/modules/",
    basename(get_terragrunt_dir())
  ])

  extra_arguments "required_var_files" {
    commands = [
      "apply",
      "plan",
      "destroy",
    ]
    required_var_files = [
      for file in local.required_var_files :
      "${get_repo_root()}/vars/${file}.tfvars"
    ]
  }
}

locals {
  required_var_files = [
    "vault"
  ]

  config_templates = {
    providers = [
      {
        name = "tls"
      }
    ]

    required_providers = [
      {
        name = "tls"
      }
    ]

    locals = [
      {
        name = "ingress-class-mapping"
      }
    ]

    vars = [
      {
        name = "helm"
      },
      {
        name = "deployment-config"
      },
      {
        name = "tls-ca-cert"
      },
      {
        name = "tls-intermediate-cert"
      },
      {
        name = "tls-intermediate-key"
      },
      {
        name = "url"
      },
      {
        name = "configs-abspath"
      },
      {
        name = "platform"
      },
      {
        name = "project"
      },
      {
        name = "vault-subdomain"
      },
      // {
      //   name = "ingress-sg"
      // },
      {
        name = "cluster-ca"
      }
    ]
  }
}

// generate "generated_config_module" {
//   path      = "generated-config.module.tf"
//   if_exists = "overwrite"
//   contents = join("\n", ([
//     for key, items in local.config_templates :
//     (join("\n", [
//       for j, template in items :
//       templatefile(
//         "${get_repo_root()}/src/templates/${key}/${template.name}.tftpl.hcl",
//         try(template.args, {})
//       )
//     ]))
//   ]))
// }
