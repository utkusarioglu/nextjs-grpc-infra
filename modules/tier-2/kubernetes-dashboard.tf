resource "helm_release" "kubernetes_dashboard" {
  count             = local.deployment_configs.kubernetes_dashboard.count
  repository        = "https://kubernetes.github.io/dashboard"
  chart             = "kubernetes-dashboard"
  name              = "kubernetes-dashboard"
  version           = "5.11.0"
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
          "kubernetes-dashboard.${var.sld}.${var.tld}"
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
