data "kubernetes_service" "kubernetes" {
  metadata {
    name      = "kubernetes"
    namespace = "default"
  }
}
