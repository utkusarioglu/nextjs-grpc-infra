inputs = {
  project_name       = "nextjs-grpc"
  project_name_short = "ng"

  sld = "nextjs-grpc.utkusarioglu"
  tld = "com"

  vault_subdomain                = "vault"
  grafana_subdomain              = "grafana"
  prometheus_subdomain           = "prometheus"
  jaeger_subdomain               = "jaeger"
  kubernetes_dashboard_subdomain = "kubernetes-dashboard"

  project_root_abspath = abspath("${get_repo_root()}/..")

  configs_abspath   = "${get_repo_root()}/src/configs"
  secrets_abspath   = "${get_repo_root()}/secrets"
  artifacts_abspath = "${get_repo_root()}/artifacts"
}
