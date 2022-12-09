resource "kubernetes_namespace" "all" {
  for_each = toset(local.deployment_configs.namespaces.for_each)
  metadata {
    name = each.key
  }
}
