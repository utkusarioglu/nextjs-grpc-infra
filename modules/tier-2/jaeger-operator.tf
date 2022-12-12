# resource "helm_release" "jaeger" {
#   count = local.deployment_configs.jaeger.count
#   # count             = 0
#   name              = "jaeger"
#   chart             = "${var.project_root_path}/jaeger"
#   dependency_update = true
#   namespace         = "observability"
#   timeout           = var.helm_timeout_unit
#   atomic            = var.helm_atomic
#   # wait              = true
#   # skip_crds = true

#   values = [
#     yamlencode({
#       ingress = {
#         hosts = [
#           "jaeger.${var.sld}.${var.tld}"
#         ]
#         ingressClass        = local.ingress_class_mapping[var.environment]
#         awsSecurityGroups   = var.ingress_sg
#         externalDnsHostname = "jaeger.${var.sld}.${var.tld}"
#       }
#     })
#   ]
# }

resource "helm_release" "jaeger_operator" {
  count = local.deployment_configs.jaeger_operator.count
  # count             = 0
  name       = "jaeger-operator"
  chart      = "jaeger-operator"
  repository = "https://jaegertracing.github.io/helm-charts"
  version    = "2.38.0"
  namespace  = "observability"
  timeout    = var.helm_timeout_unit
  atomic     = var.helm_atomic
}

# resource "helm_release" "jaeger" {
#   count = local.deployment_configs.jaeger.count
#   # count             = 0
#   name              = "jaeger"
#   chart             = "${var.project_root_path}/jaeger"
#   dependency_update = true
#   namespace         = "observability"
#   timeout           = var.helm_timeout_unit
#   atomic            = var.helm_atomic
#   # wait              = true
#   # skip_crds = true

#   values = [
#     yamlencode({
#       ingress = {
#         hosts = [
#           "jaeger.${var.sld}.${var.tld}"
#         ]
#         ingressClass        = local.ingress_class_mapping[var.environment]
#         awsSecurityGroups   = var.ingress_sg
#         externalDnsHostname = "jaeger.${var.sld}.${var.tld}"
#       }
#     })
#   ]
#   depends_on = [
#     helm_release.jaeger_operator[0]
#   ]
# }

resource "kubernetes_cluster_role_v1" "jaeger_operator" {
  count = local.deployment_configs.jaeger_operator.count

  metadata {
    # name = "jaeger-operator"
    name = helm_release.jaeger_operator[0].metadata[0].name
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["list", "get", "watch"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["list", "get", "watch"]
  }
}

resource "kubernetes_cluster_role_binding_v1" "example" {
  count = local.deployment_configs.jaeger_operator.count
  metadata {
    name = "jaeger-operator"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    # name      = "jaeger-operator"
    name = kubernetes_cluster_role_v1.jaeger_operator[0].metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = "jaeger-operator"
    namespace = "observability"
  }
  # 
}
