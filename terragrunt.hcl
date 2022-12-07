
inputs = {
  cluster_name = "nextjs-grpc"

  sld = "nextjs-grpc.utkusarioglu"
  tld = "com"

  persistent_volumes_root = "/var/lib/rancher/k3s/storage"
  project_root_path       = ".."

  deployment_mode = "all"

  helm_timeout_unit = 400
  helm_atomic       = true

  assets_path           = "${get_repo_root()}/assets"
  secrets_path          = "${get_repo_root()}/secrets"
  intermediate_crt_path = "${get_repo_root()}/.certs/intermediate/intermediate.crt"
  intermediate_key_path = "${get_repo_root()}/.certs/intermediate/intermediate.key"
  ca_crt_path           = "${get_repo_root()}/.certs/root/root.crt"

  vault_subdomain = "vault"
}

locals {
  cluster_name = "nextjs-grpc-infra-target-local"
}

generate "helm_provider" {
  path      = "provider.helm.generated.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "helm" {
      kubernetes {
        config_path    = "~/.kube/config"
        config_context = "k3d-${local.cluster_name}"
      }
      experiments {
        manifest = true
      }
    }
  EOF
}

generate "kubernetes_provider" {
  path      = "provider.kubernetes.generated.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "kubernetes" {
      config_path    = "~/.kube/config"
      config_context = "k3d-${local.cluster_name}"
    }
  EOF
}
