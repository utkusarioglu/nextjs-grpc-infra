
inputs = {
  // cluster_name = "nextjs-grpc" # common.tfvars

  sld = "nextjs-grpc.utkusarioglu"
  tld = "com"

  persistent_volumes_root = "/var/lib/rancher/k3s/storage"
  project_root_path       = "/utkusarioglu-com/projects/nextjs-grpc"

  deployment_mode = "all"

  helm_timeout_unit = 600
  helm_atomic       = true

  assets_path           = "${get_repo_root()}/assets"
  secrets_path          = "${get_repo_root()}/secrets"
  intermediate_crt_path = "${get_repo_root()}/.certs/intermediate/intermediate.crt"
  intermediate_key_path = "${get_repo_root()}/.certs/intermediate/intermediate.key"
  ca_crt_path           = "${get_repo_root()}/.certs/root/root.crt"

  vault_subdomain = "vault"

  environment = "local"
}

locals {
  cluster_name = "nextjs-grpc-infra-target-local"
}

generate "provider_helm_local" {
  path      = "provider.helm.local.generated.tf"
  if_exists = "overwrite"
  contents = templatefile("${get_repo_root()}/assets/templates/provider/helm.local.tftpl.hcl", {
    cluster_name = local.cluster_name
  })
}

generate "provider_kubernetes_local" {
  path      = "provider.kubernetes.local.generated.tf"
  if_exists = "overwrite"
  contents = templatefile("${get_repo_root()}/assets/templates/provider/kubernetes.local.tftpl.hcl", {
    cluster_name = local.cluster_name
  })
}
