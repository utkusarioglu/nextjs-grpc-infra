resource "helm_release" "jaeger_operator" {
  count      = local.deployment_configs.jaeger_operator.count
  name       = var.jaeger_operator_resource_name
  chart      = var.jaeger_operator_resource_chart
  repository = var.jaeger_operator_resource_repository
  version    = var.jaeger_operator_resource_version
  namespace  = "observability"
  timeout    = var.helm_timeout_unit
  atomic     = var.helm_atomic
}
