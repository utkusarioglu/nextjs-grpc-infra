resource "helm_release" "jaeger" {
  count             = local.deployment_configs.jaeger.count
  name              = "jaeger"
  chart             = "${var.project_root_path}/jaeger"
  dependency_update = true
  namespace         = "observability"
  timeout           = var.helm_timeout_unit
  atomic            = var.helm_atomic

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
