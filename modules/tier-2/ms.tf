resource "helm_release" "ms" {
  count             = local.deployment_configs.ms.count
  name              = "ms"
  chart             = "${var.project_root_path}/ms/.helm"
  dependency_update = true
  namespace         = "ms"
  timeout           = var.helm_timeout_unit
  atomic            = var.helm_atomic
  # depends_on = [
  #   helm_release.certificates[0]
  # ]

  set {
    name  = "cloudProvider.isLocal"
    value = "true"
  }

  set {
    name = "env.OTEL_TRACE_HOST"
    # value = "otel-trace-opentelemetry-collector.observability"
    value = "otel-trace-collector.observability"
  }

  set {
    name  = "env.OTEL_TRACE_PORT"
    value = "4317"
  }

  set {
    name  = "env.GRPC_CHECK_CLIENT_CERT"
    value = false
  }

  set {
    name  = "GRPC_SERVER_CERT_PATH"
    value = "/utkusarioglu/workshops/nextjs-grpc/ms/.certs/grpc-server"
  }

  set {
    name  = "GRPC_LOG_VERBOSITY"
    value = "DEBUG"
  }

  set {
    name  = "GRPC_TRACE"
    value = "all"
  }
}
