inputs = {
  cluster_name = "nextjs-grpc" # common.tfvars

  sld = "nextjs-grpc.utkusarioglu"
  tld = "com"

  persistent_volumes_root = "/var/lib/rancher/k3s/storage"
  project_root_path       = "/utkusarioglu-com/projects/nextjs-grpc"

  assets_path    = "${get_repo_root()}/assets"
  secrets_path   = "${get_repo_root()}/secrets"
  artifacts_path = "${get_repo_root()}/artifacts"
}
