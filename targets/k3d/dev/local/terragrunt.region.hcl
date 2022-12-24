
inputs = {
  region            = "local"
  deployment_mode   = "all"
  helm_timeout_unit = 180
  helm_atomic       = true
  vault_subdomain   = "vault"
}

locals {
  k3d_cluster_name = "nextjs-grpc-infra-target-local"
  config_templates = {
    providers = [
      {
        name = "helm-local"
        args = {
          cluster_name = local.k3d_cluster_name
        }
      },
      {
        name = "kubernetes-local"
        args = {
          cluster_name = local.k3d_cluster_name
        }
      },
    ]
  }
}

generate "generated_config_region" {
  path      = "generated-config.region.tf"
  if_exists = "overwrite"
  contents = join("\n", ([
    for key, items in local.config_templates :
    (join("\n", [
      for j, template in items :
      templatefile(
        "${get_repo_root()}/assets/templates/${key}/${template.name}.tftpl.hcl",
        try(template.args, {})
      )
    ]))
  ]))
}
