resource "helm_release" "prometheus" {
  count             = local.deployment_configs.prometheus.count
  name              = "prometheus"
  chart             = "${var.project_root_path}/prometheus"
  dependency_update = true
  namespace         = "observability"
  timeout           = var.helm_timeout_unit
  atomic            = var.helm_atomic

  set {
    name  = "prometheus.server.ingress.hosts"
    value = "{prometheus.${var.sld}.${var.tld}}"
  }

  set {
    name  = "prometheus.server.ingress.annotations.${replace("kubernetes.io/ingress.class", ".", "\\.")}"
    value = local.ingress_class_mapping[var.environment]
  }

  set {
    name  = "prometheus.server.ingress.annotations.${replace("alb.ingress.kubernetes.io/security-groups", ".", "\\.")}"
    value = var.ingress_sg
  }

  set {
    name  = "prometheus.server.ingress.annotations.${replace("external-dns.alpha.kubernetes.io/hostname", ".", "\\.")}"
    value = "prometheus.${var.sld}.${var.tld}"
  }
}
