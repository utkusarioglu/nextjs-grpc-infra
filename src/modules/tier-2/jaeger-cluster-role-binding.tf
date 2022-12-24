resource "kubernetes_cluster_role_binding_v1" "example" {
  count = local.deployment_configs.jaeger_operator.count
  metadata {
    name = "jaeger-operator"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.jaeger_operator[0].metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = "jaeger-operator"
    namespace = "observability"
  }
}
