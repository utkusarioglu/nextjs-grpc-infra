resource "helm_release" "grafana_operator" {
  count      = local.deployment_configs.grafana_operator.count
  name       = var.grafana_operator_resource_name
  chart      = var.grafana_operator_resource_chart
  repository = var.grafana_operator_resource_repository
  version    = var.grafana_operator_resource_version
  namespace  = "observability"
  timeout    = var.helm_timeout_unit
  atomic     = var.helm_atomic
}
