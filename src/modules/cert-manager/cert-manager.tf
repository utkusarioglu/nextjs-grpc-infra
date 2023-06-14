resource "helm_release" "cert_manager" {
  count             = local.deployment_configs.cert_manager.count
  name              = var.cert_manager_resource_name
  chart             = var.cert_manager_resource_chart
  repository        = var.cert_manager_resource_repository
  version           = var.cert_manager_resource_version
  namespace         = "cert-manager"
  dependency_update = true
  timeout           = var.helm_timeout_unit * 3
  atomic            = var.helm_atomic

  set {
    name  = "installCRDs"
    value = true
  }
}
