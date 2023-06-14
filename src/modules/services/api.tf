resource "helm_release" "api" {
  count             = local.deployment_configs.api.count
  name              = "api"
  chart             = "${var.project_root_abspath}/api/.helm"
  dependency_update = true
  namespace         = "api"
  timeout           = var.helm_timeout_unit * 5
  atomic            = var.helm_atomic


  values = [
    yamlencode({
      env = {
        RUN_MODE                = "production",
        NEXT_PUBLIC_DOMAIN_NAME = "${var.sld}.${var.tld}"
        SCHEME                  = "https"
        GRPC_VERBOSITY          = "debug"
        GRPC_TRACE              = "connectivity_state"
      }
      service = {
        type = local.ingress_service_types[var.platform]
      }
      ingress = {
        annotations = {
          "kubernetes.io/ingress.class"               = local.ingress_class_mapping[var.platform]
          "alb.ingress.kubernetes.io/security-groups" = var.ingress_sg
          "external-dns.alpha.kubernetes.io/hostname" = "${var.sld}.${var.tld}"
        }
        hosts = [
          {
            host = "${var.sld}.${var.tld}"
            paths = [
              {
                path     = local.ingress_paths.api[var.platform]
                pathType = "ImplementationSpecific"
              }
            ]
          }
        ]
      }
    })
  ]
}
