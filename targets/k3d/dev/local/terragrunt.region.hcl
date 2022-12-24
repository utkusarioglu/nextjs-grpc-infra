
inputs = {
  // cluster_name = "nextjs-grpc" # common.tfvars

  // sld = "nextjs-grpc.utkusarioglu"
  // tld = "com"

  // persistent_volumes_root = "/var/lib/rancher/k3s/storage"
  // project_root_path       = "/utkusarioglu-com/projects/nextjs-grpc"

  deployment_mode = "all"

  helm_timeout_unit = 600
  helm_atomic       = true

  // assets_path           = "${get_repo_root()}/assets"
  // secrets_path          = "${get_repo_root()}/secrets"
  // intermediate_crt_path = "${get_repo_root()}/.certs/intermediate/intermediate.crt"
  // intermediate_key_path = "${get_repo_root()}/.certs/intermediate/intermediate.key"
  // ca_crt_path           = "${get_repo_root()}/.certs/root/root.crt"

  vault_subdomain = "vault"

  environment = "local"
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
