resource "kubernetes_service_account" "services_issuer" {
  # depends_on = [
  #   kubernetes_namespace.all
  # ]
  for_each = (
    local.deployment_configs.certificates.count > 0
    ? local.deployment_configs.cert_namespaces.for_each
    : toset([])
  )

  metadata {
    name      = "services-issuer"
    namespace = each.key
  }
}


resource "kubernetes_secret_v1" "services_issuer" {
  depends_on = [
    kubernetes_service_account.services_issuer
  ]
  for_each = (
    local.deployment_configs.certificates.count > 0
    ? toset(local.deployment_configs.cert_namespaces.for_each)
    : toset([])
  )
  metadata {
    name      = "services-issuer-service-account-token"
    namespace = each.key
    annotations = {
      "kubernetes.io/service-account.name" = (
        kubernetes_service_account.services_issuer[each.key].metadata[0].name
      )
    }
  }

  type = "kubernetes.io/service-account-token"
}
