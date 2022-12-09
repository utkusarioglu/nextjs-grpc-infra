resource "helm_release" "rbac" {
  count             = local.deployment_configs.rbac.count
  name              = "rbac"
  chart             = "${var.project_root_path}/rbac"
  dependency_update = true
  atomic            = true

  depends_on = [
    kubernetes_namespace.all["api"],
    kubernetes_namespace.all["ms"],
    kubernetes_namespace.all["observability"],
    kubernetes_namespace.all["cert-manager"],
  ]
}
