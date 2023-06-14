resource "helm_release" "secrets" {
  count             = local.deployment_configs.secrets.count
  name              = "secrets"
  chart             = "${var.project_root_abspath}/secrets"
  dependency_update = true
  atomic            = true

  # depends_on = [
  #   kubernetes_namespace.all["api"],
  #   kubernetes_namespace.all["ms"],
  #   kubernetes_namespace.all["observability"],
  #   kubernetes_namespace.all["cert-manager"],
  # ]
}
