resource "kubernetes_cluster_role_v1" "jaeger_operator" {
  count = local.deployment_configs.jaeger_operator.count

  metadata {
    name = helm_release.jaeger_operator[0].metadata[0].name
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["list", "get", "watch"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["list", "get", "watch"]
  }
}
