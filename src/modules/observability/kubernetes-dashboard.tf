resource "helm_release" "kubernetes_dashboard" {
  count             = local.deployment_configs.kubernetes_dashboard.count
  repository        = var.kubernetes_dashboard_resource_repository
  chart             = var.kubernetes_dashboard_resource_chart
  name              = var.kubernetes_dashboard_resource_name
  version           = var.kubernetes_dashboard_resource_version
  namespace         = "observability"
  dependency_update = true
  atomic            = true

  values = [
    yamlencode({
      ingress = {
        enabled = true
        annotations = {
          "kubernetes.io/ingress.class" = "public"
        }
        hosts = [
          "${var.kubernetes_dashboard_subdomain}.${var.sld}.${var.tld}"
        ]
      }
    })
  ]
}

resource "kubernetes_service_account" "kubernetes_dashboard" {
  count = local.deployment_configs.kubernetes_dashboard.count

  metadata {
    name      = "admin-user"
    namespace = "observability"
  }

  depends_on = [
    helm_release.kubernetes_dashboard[0]
  ]
}

resource "kubernetes_cluster_role_binding" "kubernetes_dashboard" {
  count = local.deployment_configs.kubernetes_dashboard.count

  metadata {
    name = "admin-user"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "admin-user"
    namespace = "observability"
  }

  depends_on = [
    helm_release.kubernetes_dashboard[0],
    kubernetes_service_account.kubernetes_dashboard[0]
  ]
}
