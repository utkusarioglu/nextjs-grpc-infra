
inputs = {
  cluster_name            = "nextjs-grpc"
  sld                     = "nextjs-grpc.utkusarioglu"
  tld                     = "com"
  persistent_volumes_root = "/var/lib/rancher/k3s/storage"

  project_root_path = ".."
  helm_timeout_unit = 400
  helm_atomic       = true
  deployment_mode   = "all"

  assets_path  = "assets"
  secrets_path = "secrets"

  intermediate_crt = file(".certs/intermediate/intermediate.crt")
  intermediate_key = file(".certs/intermediate/intermediate.key")
  ca_crt           = file(".certs/root/root.crt")

  vault_subdomain = "vault"

}

locals {
  cluster_name = "nextjs-grpc-infra-target-local"
}

generate "providers" {
  path      = "providers.generated.tf"
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

    provider "kubernetes" {
      config_path    = "~/.kube/config"
      config_context = "k3d-${local.cluster_name}"
    }
  EOF
}
