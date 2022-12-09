resource "helm_release" "api" {
  count             = local.deployment_configs.api.count
  name              = "api"
  chart             = "${var.project_root_path}/api/.helm"
  dependency_update = true
  namespace         = "api"
  timeout           = var.helm_timeout_unit
  atomic            = var.helm_atomic
  depends_on = [
    helm_release.ms[0]
  ]

  set {
    name  = "env.MS_HOST"
    value = "ms.ms"
  }

  set {
    name  = "env.OTEL_TRACE_HOST"
    value = "otel-trace-collector.observability"
  }

  set {
    name  = "env.OTEL_TRACE_PORT"
    value = "4317"
  }

  set {
    name  = "env.NEXT_PUBLIC_DOMAIN_NAME"
    value = "${var.sld}.${var.tld}"
  }

  set {
    name  = "env.SCHEME"
    value = "https"
  }

  set {
    name  = "ingress.annotations.${replace("kubernetes.io/ingress.class", ".", "\\.")}"
    value = local.ingress_class_mapping[var.environment]
  }

  set {
    name  = "ingress.hosts[0].host"
    value = "${var.sld}.${var.tld}"
  }

  set {
    name  = "ingress.hosts[0].paths[0].path"
    value = local.ingress_paths.api[var.environment]
  }

  set {
    name  = "ingress.hosts[0].paths[0].pathType"
    value = "ImplementationSpecific"
  }

  set {
    name  = "ingress.annotations.${replace("alb.ingress.kubernetes.io/security-groups", ".", "\\.")}"
    value = var.ingress_sg
  }

  set {
    name  = "grafana.ingress.annotations.${replace("external-dns.alpha.kubernetes.io/hostname", ".", "\\.")}"
    value = "${var.sld}.${var.tld}"
  }

  set {
    name  = "service.type"
    value = local.ingress_service_types[var.environment]
  }
}
