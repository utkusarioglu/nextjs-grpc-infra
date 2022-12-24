resource "kubernetes_namespace" "ingress" {
  count = 1
  metadata {
    name = "ingress"
    labels = {
      repo      = "infra-target-local"
      submodule = "ingress"
    }
  }
}
