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

# resource "helm_release" "jaeger_operator" {
#   count = local.deployment_configs.jaeger.count
#   # count             = 0
#   name       = "jaeger-operator"
#   chart      = "jaeger-operator"
#   repository = "https://jaegertracing.github.io/helm-charts"
#   version    = "2.38.0"
#   namespace  = "observability"
#   timeout    = var.helm_timeout_unit
#   atomic     = var.helm_atomic
# }

resource "helm_release" "jaeger" {
  count = local.deployment_configs.jaeger.count
  # count             = 0
  name              = "jaeger"
  chart             = "${var.project_root_path}/jaeger"
  dependency_update = true
  namespace         = "observability"
  timeout           = var.helm_timeout_unit
  atomic            = var.helm_atomic
  # wait              = true
  # skip_crds = true

  values = [
    yamlencode({
      ingress = {
        hosts = [
          "jaeger.${var.sld}.${var.tld}"
        ]
        ingressClass        = local.ingress_class_mapping[var.environment]
        awsSecurityGroups   = var.ingress_sg
        externalDnsHostname = "jaeger.${var.sld}.${var.tld}"
      }
    })
  ]
}
