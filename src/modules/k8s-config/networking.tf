resource "helm_release" "networking" {
  count             = local.deployment_configs.networking.count
  name              = "networking"
  chart             = "${var.project_root_abspath}/networking"
  dependency_update = true
  atomic            = true

  # depends_on = [
  #   kubernetes_namespace.all["api"],
  #   kubernetes_namespace.all["ms"],
  #   kubernetes_namespace.all["observability"],
  #   kubernetes_namespace.all["cert-manager"],
  # ]
}
