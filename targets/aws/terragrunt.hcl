
inputs = {
  cluster_name = "nextjs-grpc"

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

generate "provider_aws_aws" {
  path      = "provider.aws.aws.generated.tf"
  if_exists = "overwrite"
  contents = templatefile("${get_repo_root()}/assets/templates/provider/aws.aws.tftpl.hcl", {
    // cluster_region = var.cluster_region,
    // profile        = var.aws_profile,
    // tags           = var.aws_provider_default_tags
    cluster_region = "eu-central-1"
    aws_profile    = "utkusarioglu"
    // aws_provider_default_tags = {
    //   Environment     = "dev"
    //   ProjectName     = "nextjs-grpc"
    //   MetaRepo        = "nextjs-grpc"
    //   Repo            = "infra/aws"
    //   Region          = "Cluster region"
    //   DefaultProvider = "true"
    // }

  })
}
