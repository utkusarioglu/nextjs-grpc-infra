resource "helm_release" "grafana" {
  // TODO this is off on kubernetes 1.25 because of podSecurityPolicy deprecation
  count             = local.deployment_configs.grafana.count
  name              = "grafana"
  chart             = "${var.project_root_path}/grafana"
  dependency_update = true
  namespace         = "observability"
  timeout           = var.helm_timeout_unit
  atomic            = var.helm_atomic
  recreate_pods     = true

  set {
    name  = "grafana.ingress.hosts"
    value = "{grafana.${var.sld}.${var.tld}}"
  }

  set {
    name  = "grafana.ingress.annotations.${replace("kubernetes.io/ingress.class", ".", "\\.")}"
    value = local.ingress_class_mapping[var.environment]
  }

  set {
    name  = "grafana.ingress.annotations.${replace("alb.ingress.kubernetes.io/security-groups", ".", "\\.")}"
    value = var.ingress_sg
  }

  set {
    name  = "grafana.ingress.annotations.${replace("external-dns.alpha.kubernetes.io/hostname", ".", "\\.")}"
    value = "grafana.${var.sld}.${var.tld}"
  }

  set {
    name  = "grafana.service.type"
    value = local.ingress_service_types[var.environment]
  }
}
