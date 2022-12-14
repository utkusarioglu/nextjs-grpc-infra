resource "helm_release" "ingress" {
  count      = local.deployment_configs.ingress.count
  name       = var.ingress_nginx_resource_name
  chart      = var.ingress_nginx_resource_chart
  repository = var.ingress_nginx_resource_repository
  version    = var.ingress_nginx_resource_version
  namespace  = kubernetes_namespace.ingress[0].metadata[0].name
  timeout    = var.helm_timeout_unit * 2
  atomic     = var.helm_atomic

  values = [
    yamlencode({
      controller = {

        metrics = {
          enabled = true
        }
        ingressClass = "public"
        ingressClassResource = {
          name    = "public"
          default = true
        }

        config = {
          enable-opentracing              = "false"
          opentracing-trust-incoming-span = "true"
          jaeger-collector-host           = "otel-trace-collector.observability"
          opentracing-operation-name      = "public"
        }

        extraArgs = {
          default-ssl-certificate = join("/", [
            kubernetes_namespace.ingress[0].metadata[0].name,
            kubernetes_secret.ingress_server_cert[0].metadata[0].name
          ])
          # enable-ssl-passthrough = ""
        }
      }
    })
  ]
}
