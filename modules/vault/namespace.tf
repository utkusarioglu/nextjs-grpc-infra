resource "kubernetes_namespace" "this" {
  metadata {
    name = "vault"
  }
}
