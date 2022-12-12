resource "helm_release" "jaeger_operator" {
  count      = local.deployment_configs.jaeger_operator.count
  name       = "jaeger-operator"
  chart      = "jaeger-operator"
  repository = "https://jaegertracing.github.io/helm-charts"
  version    = "2.38.0"
  namespace  = "observability"
  timeout    = var.helm_timeout_unit
  atomic     = var.helm_atomic
}
