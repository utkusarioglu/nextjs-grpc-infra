
inputs = {
  deployment_mode   = "all"
  helm_timeout_unit = 60
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

generate "providers_region" {
  path      = "providers-region.generated.tf"
  if_exists = "overwrite"
  contents = join("\n", ([
    for i, identifier in local.config_templates.providers :
    (templatefile(
      "${get_repo_root()}/assets/templates/providers/${identifier.name}.tftpl.hcl",
      identifier.args
    ))
  ]))
}
