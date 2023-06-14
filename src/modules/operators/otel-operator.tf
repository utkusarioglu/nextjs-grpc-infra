resource "helm_release" "otel_operator" {
  count = local.deployment_configs.otel_operator.count

  name              = var.otel_operator_resource_name
  chart             = var.otel_operator_resource_chart
  repository        = var.otel_operator_resource_repository
  version           = var.otel_operator_resource_version
  dependency_update = true
  atomic            = var.helm_atomic
  namespace         = "observability"
  timeout           = var.helm_timeout_unit * 3

  values = [
    yamlencode({
      admissionWebhooks = {
        certManager = {
          enabled = true
        }
      }
    })
  ]
}
