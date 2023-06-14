resource "helm_release" "jaeger" {
  count = local.deployment_configs.jaeger.count

  name              = "jaeger"
  chart             = "${var.project_root_abspath}/jaeger"
  dependency_update = true
  namespace         = "observability"
  timeout           = var.helm_timeout_unit
  atomic            = var.helm_atomic

  values = [
    yamlencode({
      ingress = {
        hosts = [
          local.jaeger_url
        ]
        ingressClass        = local.ingress_class_mapping[var.platform]
        awsSecurityGroups   = var.ingress_sg
        externalDnsHostname = local.jaeger_url
      }
    })
  ]
}
