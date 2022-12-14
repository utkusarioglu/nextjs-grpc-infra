resource "helm_release" "cert_manager" {
  count             = local.deployment_configs.cert_manager.count
  name              = "cert-manager"
  chart             = "cert-manager"
  repository        = "https://charts.jetstack.io"
  dependency_update = true
  # namespace         = kubernetes_namespace.all["cert-manager"].metadata[0].name
  namespace = "cert-manager"
  timeout   = var.helm_timeout_unit * 3
  atomic    = var.helm_atomic
  version   = "v1.9.0"
  # depends_on = [
  #   kubernetes_namespace.all["cert-manager"]
  # ]

  set {
    name  = "installCRDs"
    value = true
  }
}
