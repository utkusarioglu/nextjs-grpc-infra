resource "kubernetes_namespace" "all" {
  for_each = local.deployment_configs.namespaces.for_each
  metadata {
    name = each.key
  }
}
