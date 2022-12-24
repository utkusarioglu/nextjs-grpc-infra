resource "helm_release" "otel_collectors" {
  count             = local.deployment_configs.otel_collectors.count
  name              = "otel-collectors"
  chart             = "${var.project_root_path}/otel-collectors"
  dependency_update = true
  atomic            = var.helm_atomic
  namespace         = "observability"
  timeout           = var.helm_timeout_unit
}
