resource "helm_release" "web_server" {
  count             = local.deployment_configs.web_server.count
  name              = "web-server"
  chart             = "${var.project_root_abspath}/frontend/apps/web/.helm"
  dependency_update = true
  namespace         = "api"
  timeout           = var.helm_timeout_unit * 5
  atomic            = var.helm_atomic


  values = [
    yamlencode({
      image = {
        tag = "${var.web_server_image_tag}"
      }
      env = {
        RUN_MODE                = "production",
        NEXT_PUBLIC_DOMAIN_NAME = "${var.sld}.${var.tld}"
        NEXT_PUBLIC_SCHEME      = "https"
        # GRPC_VERBOSITY          = "debug"
        # GRPC_TRACE              = "connectivity_state"
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
                path     = local.ingress_paths.web_server[var.platform]
                pathType = "ImplementationSpecific"
              }
            ]
          }
        ]
      }
    })
  ]
}
